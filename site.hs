--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Hakyll.Web.Sass
import           Data.List (isInfixOf)
import           System.FilePath.Posix (splitFileName,takeBaseName
                                        ,takeDirectory, (</>), replaceDirectory)


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

-- The functions in this section were borrowed from the Main.hs file of
-- https://github.com/mdgriffith/mechanical-elephant.

-- replace a foo/bar.md by foo/bar/index.html
-- this way the url looks like: foo/bar in most browsers
niceRoute :: Routes
niceRoute = customRoute createIndexRoute
  where
    createIndexRoute ident =
        takeDirectory (toFilePath ident) </> takeBaseName (toFilePath ident) </> "index.html"

baseRoute :: Routes
baseRoute = customRoute base
  where
    base ident = replaceDirectory (toFilePath ident) ""


niceBaseRoute :: Routes
niceBaseRoute = customRoute base
    where 
      base ident = takeBaseName (toFilePath ident) </> "index.html"

stylesheetRoute :: Routes
stylesheetRoute = customRoute cssRoute
  where
    cssRoute ident = "css" </> (takeBaseName $ toFilePath ident) ++ ".css"

-- replace url of the form foo/bar/index.html by foo/bar
removeIndexHtml :: Item String -> Compiler (Item String)
removeIndexHtml item = return $ fmap (withUrls removeIndexStr) item
  where
    removeIndexStr :: String -> String
    removeIndexStr url = case splitFileName url of
        (dir, "index.html") | isLocal dir -> dir
        _                                 -> url
    isLocal :: [Char] -> Bool
    isLocal uri = not (isInfixOf "://" uri)


static :: Pattern -> Rules ()
static f = match f $ do
    route   idRoute
    compile copyFileCompiler

directory :: (Pattern -> Rules a) -> String -> Rules a
directory act f = act $ fromGlob $ f ++ "/**"

--------------------------------------------------------------------------------

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
    { feedTitle       = "Christian Charukiewicz"
    , feedDescription = "A personal website"
    , feedAuthorName  = "Christian Charukiewicz"
    , feedAuthorEmail = "c.charukiewicz@gmail.com"
    , feedRoot        = "https://charukiewi.cz"
    }

--------------------------------------------------------------------------------

main :: IO ()
main =
    let
        myIgnoreFile ".htaccess" = False
        myIgnoreFile path        = ignoreFile defaultConfiguration path
        conf = defaultConfiguration { ignoreFile = myIgnoreFile }
    in
        hakyllWith conf $ do
        static ".htaccess"


        match "images/*" $ do
            route   idRoute
            compile copyFileCompiler

        match "files/*" $ do
            route   idRoute
            compile copyFileCompiler

        match "assets/**" $ do
            route   idRoute
            compile copyFileCompiler

        match "stylesheets/*" $ do
            route   stylesheetRoute
            compile sassCompiler


        match "pages/*" $ do
            route $ niceBaseRoute
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls
                >>= removeIndexHtml

        match "books/*" $ do
            route $ niceRoute
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls
                >>= removeIndexHtml


        match "posts/*" $ do
            route $ niceRoute
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/post.html"    postCtx
                >>= saveSnapshot "content"
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls
                >>= removeIndexHtml

        match "index.html" $ do
            route idRoute
            compile $ do
                posts <- recentFirst =<< loadAll "posts/*"
                let indexCtx =
                        listField "posts" postCtx (return posts) `mappend`
                        defaultContext

                getResourceBody
                    >>= applyAsTemplate indexCtx
                    >>= loadAndApplyTemplate "templates/default.html" indexCtx
                    >>= relativizeUrls
                    >>= removeIndexHtml

        match "templates/*" $ compile templateCompiler

        create ["atom.xml"] $ do
            route idRoute
            compile $ do
                let feedCtx = postCtx `mappend` bodyField "description"
                posts <- fmap (take 10) . recentFirst =<<
                    loadAllSnapshots "posts/*" "content"
                renderAtom myFeedConfiguration feedCtx posts


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
