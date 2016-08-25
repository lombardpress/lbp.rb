$confighash = {
								local_texts_dir: "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/GitTextfiles/", 
								citation_lists_dir: "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/citationlists/", 
								xslt_base: "/Users/jcwitt/Projects/lombardpress/lombardpress2/xslt/", 
								stylesheets: {
							 		main_view: "main_view.xsl",
							 		clean_view: "clean_view.xsl",
							 		plain_text: "plaintext.xsl", 
							 		toc: "lectio_outline.xsl"
							 	},
							 	git_repo: "bitbucket.org/jeffreycwitt/",
							 	git_username: ENV["GUN"],
							 	git_password: ENV["GPW"]
							}

		


#$filehash = {path: "https://bitbucket.org/jeffreycwitt/lectio1/raw/master/reims_lectio1.xml", fs: "lectio1", ed: "master", type: "documentary", source: "origin"}
$filehash = {path: "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/GitTextfiles/lectio1/lectio1.xml", fs: "lectio1", ed: "master", type: "critical", source: "local", commentary_id: "plaoulcommentary"}

$projectfile = "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/Conf/projectdata.xml"

$pg_projectfile = "/Users/JCWitt/WebPages/lbplib-testfiles/pg-projectfiles/Conf/projectdata.xml"

$auto_pp_projectfile = "/Users/JCWitt/WebPages/lbp.rb/pp-projectfiles/Conf/projectfile.xml"

$scta_url = "http://scta.info/text/plaoulcommentary/item/lectio1"
#$scta_url = "http://localhost:4567/text/plaoulcommentary/item/lectio1"

$commentary_url = "http://scta.info/text/plaoulcommentary/commentary"
#$commentary_url = "http://scta.info/text/wodehamordinatio/commentary"