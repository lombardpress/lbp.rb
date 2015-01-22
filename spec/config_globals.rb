$confighash = {local_texts_dir: "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/GitTextfiles/", 
							citation_lists_dir: "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/citationlists/", 
							xslt_dirs: { "default" => {
								critical: "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/public/pl_xslt_stylesheets/",
								documentary: "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/public/pl_xslt_stylesheets/", 
								main_view: "text_display.xsl",
								index_view: "text_display_index.xsl", 
								clean_view: "clean_forStatistics.xsl",
								plain_text: "plaintext.xsl", 
								toc: "lectio_outline.xsl"
									}
								},
							git_repo: "bitbucket.org/jeffreycwitt/",
							git_username: "jeffreycwitt",
							git_password: "plaoulRepo"
						}

		


#filehash = {path: "https://bitbucket.org/jeffreycwitt/lectio1/raw/master/lectio1.xml", fs: "lectio1", ed: "master", type: "critical", source: "origin"}
$filehash = {path: "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/GitTextfiles/lectio1/lectio1.xml", fs: "lectio1", ed: "master", type: "critical", source: "local", commentar_id: "plaoulcommentary"}

$projectfile = "/Users/JCWitt/WebPages/lbplib-testfiles/pp-projectfiles/Conf/projectdata.xml"

$pg_projectfile = "/Users/JCWitt/WebPages/lbplib-testfiles/pg-projectfiles/Conf/projectdata.xml"

$auto_pp_projectfile = "/Users/JCWitt/WebPages/lbp.rb/pp-projectfiles/Conf/projectfile.xml"

$scta_url = "http://scta.info/text/plaoulcommentary/item/lectio1"
#$scta_url = "http://localhost:4567/text/plaoulcommentary/item/lectio1"