mob
	verb
		Generate_New_Cipher_Alphabet()
			GenerateCipher()

		Change_CipherKey(t as text)
			cipherKey = t
			world<<"cipherKey changed to: <b>[t]</b>"

		Encrypt_String(t as text)
			var/cipherText = EnCrypt(t, cipherKey)
			world<<"<b>ENCRYPTED: </b>\n[cipherText]"

		Decrypt_String(t as text)
			var/plainText = DeCrypt(t, cipherKey)
			world<<"<b>DECRYPTED: </b>\n[plainText]"

		Cipher_Character(t as text)
			if(length(t) > 1) t = copytext(t,1,2)

			var/index = encrypt.Find(t)

			if(!index)
				world<<"[t] is not in the cipher alphabet."
				return

			world<<"[t]: [encrypt[encrypt[t]]] ([encrypt[t]])"