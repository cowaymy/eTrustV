package com.coway.trust.config.ctos.client.xml.proxy.ws;

public class RequestData {

	private RequestData() {
	}

	public static String PrepareRequest(String batchNo, String orderNo, String customerName, String nric) {

		String companyCode = "B065000";
		String accountNo = "B065000";
		String userId = "b065000_xml";

		StringBuilder sb = new StringBuilder();

		sb.append("<batch output=\"0\" no=\"" + batchNo + "\" xmlns=\"http://ws.cmctos.com.my/ctosnet/request\">"
				+ "\r\n");
		sb.append("<company_code>" + companyCode + "</company_code>" + "\r\n");
		sb.append("<account_no>" + accountNo + "</account_no>" + "\r\n");
		sb.append("<user_id>" + userId + "</user_id>" + "\r\n");
		sb.append("<record_total>1</record_total>" + "\r\n");
		sb.append("<records>" + "\r\n");
		sb.append("<type>I</type>" + "\r\n");// I-individual,C-company,B-business
		sb.append("<ic_lc></ic_lc>" + "\r\n");// Old IC number(for individual)
												// or local number(for company)
												// or blank for business
		sb.append("<nic_br>" + nric + "</nic_br>" + "\r\n");// New IC/Passport
															// number for
															// individual, blank
															// for company,
															// business
															// registration
															// number for
															// business
		sb.append("<name>" + customerName + "</name>" + "\r\n");
		sb.append("<mphone_nos>" + "\r\n");
		sb.append("<mphone_no/>" + "\r\n");
		sb.append("</mphone_nos>" + "\r\n");
		sb.append("<ref_no/>" + "\r\n");// User's own reference or remark (for
										// example, order number)
		sb.append("<dist_code></dist_code>" + "\r\n");// User's own ditribution
														// code(e.g. branch,
														// department)
		sb.append(
				"<purpose code=\"200\">Credit evaluation/account opening on subject/directors/shareholder with consent /due diligence on AMLA compliance</purpose>"
						+ "\r\n");

		// 3rd request by christine
		sb.append("<include_consent>1</include_consent>" + "\r\n");
		sb.append("<include_ctos>1</include_ctos>" + "\r\n");
		sb.append("<include_trex>1</include_trex>" + "\r\n");
		sb.append("<include_ccris sum=\"1\">1</include_ccris>" + "\r\n");
		sb.append("<include_dcheq>1</include_dcheq>" + "\r\n");
		sb.append("<include_fico>1</include_fico>" + "\r\n");
		sb.append("<include_ssm>0</include_ssm>" + "\r\n");

		sb.append("<confirm_entity>90007</confirm_entity>" + "\r\n");
		sb.append("</records>" + "\r\n");
		sb.append("</batch>");

		return sb.toString();
	}
}
