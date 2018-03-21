package com.nuclear.dota.oversea;

/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import com.google.android.vending.expansion.downloader.impl.DownloaderService;

/**
 * This class demonstrates the minimal client implementation of the
 * DownloaderService from the Downloader library. Since services must be
 * uniquely registered across all of Android it's a good idea for services to
 * reside directly within your Android application package.
 */
public class MyDownloaderService extends DownloaderService {
	// stuff for LVL -- MODIFY FOR YOUR APPLICATION!
	private static final String BASE64_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAonXlxMTIz8zwwhS0otKkzF6b2aKcvMl0Ye3fQhLhm85jfRWya0x845kqaFG1nxSizJQY3niE0hiVvbKtFB8ssT4ma4tU9byLBDtTUwKX2mqc4q01C5nGSon3ocllgskgfmXEKGRejbhxDb9qu4hL0O5gZPnLPIyba8NqAgb9iYnXVXp8me4XahnhzBBn+yHRP8dmR0IrpixswdKmEuvyF/M96ix3xmr4CfRAK51mOjDtciq4CXlbsFZTi+TIg0cvLpwktw37g3HYCpkmp9ocuWGBlH1DO4ug6ZLrziOZNK0/Do1t72pt+axwWlk0zncsqwlXldL8BN12LapoDBk2TQIDAQAB";
	// used by the preference obfuscater
	private static final byte[] SALT = new byte[] { -12, -69, -12, -77, 75,
			-83, -63, -61, -72, -62, 116, -54, -61, 50, -88, -79, -73, -92,
			-11, 39, -17, 68, 71, -128, -102, -28, 83, 114, -115, 32 };

	/**
	 * This public key comes from your Android Market publisher account, and it
	 * used by the LVL to validate responses from Market on your behalf.
	 */
	@Override
	public String getPublicKey() {
		return BASE64_PUBLIC_KEY;
	}

	/**
	 * This is used by the preference obfuscater to make sure that your
	 * obfuscated preferences are different than the ones used by other
	 * applications.
	 */
	@Override
	public byte[] getSALT() {
		return SALT;
	}

	/**
	 * Fill this in with the class name for your alarm receiver. We do this
	 * because receivers must be unique across all of Android (it's a good idea
	 * to make sure that your receiver is in your unique package)
	 */
	@Override
	public String getAlarmReceiverClassName() {
		return MyAlarmReceiver.class.getName();
	}

}
