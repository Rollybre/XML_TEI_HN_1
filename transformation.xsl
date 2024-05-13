<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <!--- Le but de cette feuilel de transformation est de passer de l'encodage XML en un document HTML, qui reprend la forme de la page originale, 
        tout en ajoutant des informations contextuelles et une coloration des topic les plus important -->
   
        <xsl:template match="/">
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
                    <title>Transformation TEI vers HTML</title>
                    <!--- Balise CSS qui va permettre de modifier l'affichage dce façon plus simple qu'en HTML pur-->
                   <style> 
                   .topic_peur {color:red;}
                    .topic_famille { color: blue; }
                    .topic_souvenir { color: green; }
                    .topic_enfance { color: orange; }
                    .topic_technologie { color: purple; }
                    .topic_jouet { color: brown; }
                    .topic_son { color: teal; }
                    .topic_sommeil { color: gray; }
                
                   <!--- Gestion des notes de bas de pages  -->
                       
                       
                   .note-link {
                   text-decoration: none;
                   color: blue;
                   }
                   
                   #footnotes {
                   margin-top: 20px;
                   padding-top: 20px;
                   border-top: 1px solid #ccc;
                   }
                   
                   #footnotes li {
                   margin-top: 10px;
                   }
                   
     
                    
                   </style>
                    
                </head>
                <body>
                    <xsl:apply-templates/>
                </body>
            </html>
        </xsl:template>
      
        <xsl:template match="tei:teiHeader"/>
            
    <!--- On prend la balise titre et on la transforme en une balise h1, qui permet d'afficher du texte en titre  au format HTML-->
        <xsl:template match="tei:div[@type = 'title']">
            <h1><xsl:value-of select="."/></h1>
        </xsl:template>
    <!--- On modifie les balises <lb/> avec leur équivalent en HTML -->
    <xsl:template match="tei:lb">
        <br/>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--- Ici, on transforme les éléments seg en élément span qui a pour classe le nom du topic, cela permet de lier les éléments CSS vu plus tôt et d'afficher les mots en couleurs -->
       
    <xsl:template match="tei:seg">
        <span>
            <xsl:attribute name="class">
                <!---Il faut juste faire attention à garder uniquement le nom de l'attributs, sans le #-->
                <xsl:value-of select="substring-after(@corresp, '#')"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
 
    <!---On affiche tout le texte-->
        <xsl:template match="p">
            <p><xsl:value-of select="."/></p>
            <xsl:apply-templates/> 
        </xsl:template>
    
    
    <!--- On affiche en gras les éléments dont l'attribut rend vaut "bold", gâce à la balise strong-->
    
    <xsl:template match="tei:head[@rend='bold']">
        <strong><xsl:value-of select="."/></strong>
    </xsl:template>
    
    <xsl:template match="tei:seg[@type='erreur']">
        <u><xsl:value-of select="."/></u>
    </xsl:template>
    
    <!-- ici, on va traiter les notes de bas de pages-->
    
    
    <xsl:template match="tei:body">
        <body>
            <xsl:apply-templates select="tei:div"/>
        </body>
    </xsl:template>
    
    <!-- Template pour traiter chaque div -->
    <xsl:template match="tei:div">
        <div>
            <xsl:apply-templates/>
        </div>
        <!-- Vérifier si c'est le dernier div et ajouter les notes de bas de page ici -->
        <xsl:if test="not(following-sibling::tei:div)">
            <footer>
                <ol id="footnotes">
                    <xsl:apply-templates select="//tei:note" mode="footnote"/>
                </ol>
            </footer>
        </xsl:if>
    </xsl:template>
    
    <!-- Crée un lien vers la note de bas de page avec un numéro automatique -->
    
    <xsl:template match="tei:note">
        <a href="#note{generate-id(.)}">
            <xsl:text>[</xsl:text>
            <xsl:number level="any" count="tei:note"/>
            <xsl:text>]</xsl:text>
        </a>
    </xsl:template>
    <!-- Créer la note au bas de la page avec le contenu de la note dans le document XML et un id_généré précédemment -->
    <xsl:template match="tei:note" mode="footnote">
        <li id="note{generate-id(.)}">
            <xsl:apply-templates select="node()"/>
        </li>
    </xsl:template>
    
    
    </xsl:stylesheet>
    
