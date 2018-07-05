require 'tk'

class Valeurs
	attr_accessor :nom,:val

	def initialize(nom,val)
		@nom = nom
		@val = val
	end

	def affiche
		print "#{@nom}, #{@val}"
	end
end

#le tableau des valeurs (@tout)
class Tableau
	
	def initialize
		@tout = []	
	end

	def ajoute(objet)
		@tout << objet
	end

	def parcours
		@tout.each {|valeur| puts "#{valeur.nom},#{valeur.val}"}
	end
	
	#pour savoir s'il existe déjà une valeur portant le nom "nom"
	def eviteDoublons(nom)
		doublon = false
		@tout.each {|valeur| if valeur.nom==nom
			doublon = true
			return doublon
		end
		}
		return doublon
	end
	
	def parcours_sansaff
		nom_val = []
		tabl2 = [];
		@tout.each do |valeur|
			nom_val << "#{valeur.nom}"
			nom_val << "#{valeur.val}"
		end
		return nom_val
	end
	
	#opération finale, quand deux opérations de bourse portent sur la même valeur, et le même montant, en sens inverses
	def changeCotation(valeur,montant)
		puts "changeCotation"
		mt = Integer(montant)
		@tout.each {|ma_valeur|
			puts "valeur : #{valeur}, ma_valeur.nom : #{ma_valeur.nom}"
			if ma_valeur.nom == valeur then
				puts "changement de valeur, mt : #{mt}"
				ma_valeur.val = mt
			end}
		parcours
	end

end

#interface graphique, la vue, la gestion des événements
class UInt
	
	@@elements = []
	@@copie_tableau = nil
	@@copie_ordres = nil
	
	def initialize(tabl,liste_o)
		@@copie_tableau = tabl
		@@copie_ordres = liste_o
		@root = TkRoot.new do
			title "Jeu de bourse"
			minsize(535,300)
		end
		accueil(@root)
=begin
		bouton_nv_valeur = TkButton.new(@root,:command => proc {ajoutVal bouton_nv_valeur,@root}) do
			text "Ajouter une valeur"
			borderwidth 5
			pack("side" => "top", "padx"=>"50", "pady"=>"10")
		end
		@@elements << bouton_nv_valeur
=end		
		Tk.mainloop
	end
	
	#affiche l'écran principal : un bouton 'ajouter une valeur', les titres des colonnes,
	#les lignes comportant les données sur les différentes valeurs et les champs permettant
	#de saisir des demandes d'opérations, avec en bas un bouton pour valider les opérations correspondant
	#aux montants saisis dans les champs
	def accueil(root)
		viderEcran
		bouton_nv_valeur = TkButton.new(@root,:command => proc {ajoutVal bouton_nv_valeur,@root}) do
			text "Ajouter une valeur"
			borderwidth 5
			pack("side" => "top", "padx"=>"50", "pady"=>"10")
		end
		@@elements << bouton_nv_valeur

		afficheTitres(root)
		
	end
	
	#les titres des colonnes : valeur, cotation, quantité à acheter, quantité à vendre, montant de l'opération
	def afficheTitres(root)
		#puts "affTitres"
		$texte = TkVariable.new
		etiquette_titre = TkLabel.new(root) do
			textvariable
			foreground "red"
			pack("side" => "top")
			place('x' => 20, 'y' => 50)
		end
		etiquette_titre['textvariable'] = $texte;
		$texte.value="Valeur"
		@@elements << etiquette_titre
		
		$texte = TkVariable.new
		etiquette_titre2 = TkLabel.new(root) do
			textvariable
			foreground "red"
			pack("side" => "top")
			place('x' => 100, 'y' => 50)
		end
		etiquette_titre2['textvariable'] = $texte;
		$texte.value = "Cotation"
		@@elements << etiquette_titre2

		$texte = TkVariable.new
		etiquette_titre3 = TkLabel.new(root) do
			textvariable
			pack("side" => "top")
			place('x' => 200, 'y' => 50)
		end
		etiquette_titre3['textvariable'] = $texte;
		$texte.value = "Acheter (unites)"
		@@elements << etiquette_titre3

		$texte = TkVariable.new		
		etiquette_titre4 = TkLabel.new(root) do
			textvariable
			pack("side" => "top")
			place('x' => 300, 'y' => 50)

		end
		etiquette_titre4['textvariable'] = $texte;
		$texte.value =  "Vendre (unites)"
		@@elements << etiquette_titre4

		$texte = TkVariable.new		
		etiquette_titre5 = TkLabel.new(root) do
			textvariable
			pack("side" => "top")
			place('x' => 400, 'y' => 50)
		end
		etiquette_titre5['textvariable'] = $texte;
		$texte.value =  "Montant"
		@@elements << etiquette_titre5
		
		Tk.update
		#puts "fin affTitres"
		afficheValeurs(root)
	end
	
	#affiche les données sur les valeurs cotées, (une ligne pour chaque valeur), et des champs
	#pour effectuer des opérations d'achat et de vente sur ces valeurs
	def afficheValeurs(root)
		#puts "affTab"
		tabl = @@copie_tableau
		index = 0
		if tabl == nil then puts "Tableau nul" end
		
		nom_val = tabl.parcours_sansaff
		#puts nom_val
		no_element = 0
		if nom_val == nil then puts "Tableau 2 nul" end
		longueur = nom_val.size
		y = 50
		nom_val.each do |element|
			#puts "dans le do"
			#element = nom_val[no_element]
			#puts "#{element}"
			y = 50 + (index + 1)*30
			if no_element % 2 == 0 then
				$texte = TkVariable.new		
				etiquette_nom = TkLabel.new(root) do
					textvariable
					pack("side" => "top")
					place('x' => 20,'y' => "#{y}")
				end
				etiquette_nom['textvariable'] = $texte;
				$texte.value = "#{element}"
				@@elements << etiquette_nom
			else
				index = index + 1
				$texte = TkVariable.new		
				etiquette_cotation = TkLabel.new(root) do
					textvariable
					pack("side" => "top")
					place('x' => 100,'y' => "#{y}")
				end
				etiquette_cotation['textvariable'] = $texte;
				$texte.value = "#{element}"
				@@elements << etiquette_cotation
				afficheQuantites(root,y)
			end
			no_element = no_element + 1
		end	
		
		afficheValider(root)
		
		Tk.update
		
		#puts "fin affTab"
	end
	
	#affiche le bouton tout en bas de l'écran principal, pour valider les opérations
	#correspondant aux montants figurant dans les champs
	def afficheValider(root)
		bouton_valider = TkButton.new(@root,:command => proc {ajOrdre @root}) do
			text "Valider"
			borderwidth 5
			pack("side" => "bottom", "padx"=>"50", "pady"=>"10")
		end
		@@elements << bouton_valider

	end
	
	def ajOrdre(root)
		#puts "ajOrdre"
		no_element = 0
		premiere_etiquette = -1
		contenu = ""
		qte = ""
		operation = ""
		@@elements.each {|el| if "#{el.class}" == "Tk::Entry" then
			contenu = el.get
			if contenu != "" then
				no_ligne = (no_element - premiere_etiquette) / 5.floor
				no_valeur = no_ligne*5 + premiere_etiquette
				type_contenu = (no_element - premiere_etiquette) % 5 #2 : quantité achetée, 3 : quantité vendue, 4 : montant
				
				case type_contenu
				#cas où le champ "quantité à acheter" a été rempli
				when 2
					qte = contenu
					operation = "1" #achat
				#cas où le champ "quantité à vendre" a été rempli
				when 3
					qte = contenu
					operation = "-1" #vente
				#on arrive au 4, qui permet d'ajouter l'ordre, parce qu'on a déjà obtenu la quantité dans le champ 2 ou 3
				#on a donc toutes les données pour ajouter un ordre (valeur, quantité, type d'opération, montant unitaire)
				when 4
					montant = contenu
					if qte != "" && operation != "" && montant != "" then
						valeur = @@elements[no_valeur]['textvariable']
						if valeur != "" then
							o = Ordre.new(valeur,operation,qte,montant,"0")
							@@copie_ordres.ajouteOrdre(o)
							@@copie_ordres.parcoursOrdres
						else
							puts "probleme, valeur = #{valeur}"
						end
					else
						puts "probleme : qte = #{qte}, operation = #{operation}, montant = #{montant}"
					end
				else
					puts "probleme, type de contenu indefini"
				end
				
			end
		elsif "#{el.class}" == "Tk::Label" then
			if premiere_etiquette == -1 then premiere_etiquette = no_element end
		end
		no_element = no_element + 1
		}
		
		#maintenant que des ordres ont peut-être été ajoutés, il y a donc peut-être
		#de nouvelles correspondances entre achats et ventes
		@@copie_ordres.executeOrdres(@@copie_tableau)
		accueil(root)
	end
	
	#affiche les champs occupant les 3 dernières colonnes (quantité à acheter, quantité à vendre, montant unitaire)
	def afficheQuantites(root,y)
		for a in 0..2
			x = 200 + a*100
			champ_qte = TkEntry.new(root)
			champ_qte.place('height' => 25, 'width' => 90,'x' => "#{x}", 'y' => "#{y}")
			@@elements << champ_qte
		end
		Tk.update
	end
	
	#affiche un nouvel écran, avec deux champs : l'un pour le nom de la nouvelle valeur, l'un pour sa cotation initiale
	def ajoutVal(bouton,root)
		viderEcran
		champ_nom = TkEntry.new(root)
		champ_nom.textvariable = "Entrez un nom"
		champ_nom.place('height' => 25, 'width' => 150,'x' => 30, 'y' => 10)
		@@elements << champ_nom
		champ_val = TkEntry.new(root)
		champ_val.textvariable = "Entrez un montant"
		champ_val.place('height' => 25, 'width' => 150,'x' => 30, 'y' => 50)
		@@elements << champ_val
		bouton_nv_val = TkButton.new(root,:command => proc {enregVal root,champ_nom,champ_val}) do
			text "Valider"
			borderwidth 5
			pack("side" => "top", "padx"=>"50", "pady"=>"100")
		end
		@@elements << bouton_nv_val
		Tk.update
	end
	
	#enregistrement dans la liste des valeurs du nom et de la cotation initiale de la nouvelle valeur
	def enregVal(root,champ_nom,champ_val)
		tabl = @@copie_tableau
		#si une valeur portant déjà le nom entré existe, on refuse la "nouvelle" valeur
		doublon_ounon = tabl.eviteDoublons(champ_nom.textvariable)
		if doublon_ounon == true
			Tk.messageBox("type" => "ok",
				"title" => "Impossible d ajouter la valeur",
				"message" => "Valeur deja cotee")
		else
			#si la nouvelle valeur est bien nouvelle, on crée la valeur, et on l'ajoute au tableau des valeurs
			v = Valeurs.new("#{champ_nom.textvariable}","#{champ_val.textvariable}")
			@@copie_tableau.ajoute(v)
		end
		#retour à l'écran principal
		accueil(root)
	end
	
	#à chaque fois qu'on ajoute un élément graphique (widget), il est stocké dans le tableau elements
	#quand on veut effacer l'écran, on parcourt le tableau elements pour récupérer chaque widget,
	#et le détruire
	def viderEcran
		@@elements.each {|el| el.destroy}
		Tk.update
		#l'écran est vide, donc il ne contient aucun élément maintenant
		@@elements=[]
	end
		
end

#ordre d'achat (operation "1") ou de vente (operation "-1")
class Ordre
	attr_accessor :val,:op,:ex,:qte,:montant
	
	def initialize(valeur,operation,quantite,mt_unitaire,execute)
		@val = valeur
		@op = operation
		@ex = execute
		@qte = quantite
		@montant = mt_unitaire
	end
	
	def affiche
		puts "#{@val},#{@op},#{@qte},#{@montant},#{@ex}"
	end
end

#la classe Ordres contient essentiellement un tableau d'éléments de type Ordre sans s
class Ordres
	
	def initialize
		@liste_ordres = []
	end
	
	def ajouteOrdre(objet)
		@liste_ordres << objet
	end
	
	def parcoursOrdres
		@liste_ordres.each {|ordr| puts "valeur : #{ordr.val}, operation : #{ordr.op}, quantite : #{ordr.qte}, montant : #{ordr.montant}, execute : #{ordr.ex}"}
	end
	
	#si à un momant donné, il existe une opération d'achat sur une valeur donnée pour un montant unitaire donné,
	#et une opération de vente sur la même valeur avec le même montant unitaire, il y a une transaction portant
	#sur la quantité la plus basse des deux, et c'est le signe qu'il faut réévaluer la cotation officielle
	#au montant unitaire de la dernière transaction
	def executeOrdres(tableau)
		@liste_ordres.each {|ordr|
			@liste_ordres.each {|ordr2|
				valeur1 = ordr.val
				valeur2 = ordr2.val
				if valeur1 == valeur2 then
					puts "valeur1 : #{valeur1}, valeur2 : #{valeur2}"
					operation1_s = ordr.op
					operation2_s = ordr2.op
					op1 = Integer(operation1_s)
					op2 = Integer(operation2_s)
					if op1 == (-op2) then
					puts "operation1 : #{op1}, operation2 : #{op2}"
						mt1 = ordr.montant
						mt2 = ordr2.montant
						if mt1 == mt2 then
							puts "mt1 : #{mt1}, mt2 : #{mt2}"
							exec1 = ordr.ex
							exec2 = ordr2.ex
							if exec1 == "0" && exec2 == "0" then
								qte1_s = ordr.qte
								qte2_s = ordr2.qte
								qte1 = Integer(qte1_s)
								qte2 = Integer(qte2_s)
								qte_min = [qte1,qte2].min
								mt_int = Integer(mt1)
								transaction = qte_min * mt_int
								Tk.messageBox("type" => "ok",
									"title" => "Montant de la transaction",
									"message" => "#{transaction}")
								ordr.ex = "1"
								ordr2.ex = "1"
								#la dernière transaction est supposée avoir été faite au prix le plus juste tel que
								#définissable avec les dernières informations, la cotation officielle (sur l'écran principal,
								#en deuxième colonne, est donc modifiée
								tableau.changeCotation(valeur1,mt1)
							end
						end
						
					end
				end
			}
		}
	end
end

#initialisation, avec deux premières valeurs et leur cotation
v = Valeurs.new("LVMH","500")
v2 = Valeurs.new("Total","150")
t = Tableau.new
t.ajoute(v)
t.ajoute(v2)
o = Ordres.new
#lancement de l'interface graphique
u = UInt.new(t,o)



