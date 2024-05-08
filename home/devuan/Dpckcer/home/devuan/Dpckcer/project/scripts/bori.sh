#!/bin/sh
#HUOM. oleeellisimpien avainten kanssa chattr +ui
#VAIH:kontissa avainten luonti ei onnaa koska käyttöoikeus-juttuja (saisikohan korjattua?)
this_make_key() {
	case ${2} in
		odin)
			gpg  --quick-gen-key ${2}
		;;
		*)
			case ${1} in
				sig)
					${checksig_base} --quick-gen-key ${2}
				;;
			esac
		;;
	esac
}

this_sign_key() {
	case ${2} in
		odin)
			gpg --sign-key ${2}
			gpg --export ${2} > ./keys/${2}.gpg
		;;
		*)
			case ${1} in
				sig)
					${checksig_base} --sign-key ${2}
				;;
			esac
		;;
	esac
}

#TODO:if-ehto toisella tavalla jatkossa. tutkitaan onko mikäkin .gpg olemassa pikemminkin  (?)
if [ -d ~/.gnupg ]; then
	echo "~/.gnupg ALR3ADY EXISTS!!!!!"
else
	for k in odin thor loki ; do
		this_make_key ${ext} ${k}
		this_sign_key sig ${k}
		#this_exp_key ${k}
	done

	gpg --export odin loki > ./keys/loki.gpg
	gpg --export odin thor > ./keys/thor.gpg
	#TODO:gpg --export-secret-keys > ./keys/gungnir.gpg
fi
