package com.coway.trust.config.ctos.client.xml.proxy.ws;

public class RequestData {

	private RequestData() {
	}

	public static String PrepareRequest(String batchNo, String orderNo, String customerName, String nric, String oldic) {

//		String companyCode = "COWAYUAT";
//		String accountNo = "COWAYUAT";
//		String userId = "coway_uat";

		String companyCode = "B065000";
		String accountNo = "B065000";
		String userId = "b065000_xml";

		StringBuilder sb = new StringBuilder();

		sb.append("<batch output=\"0\" no=\"").append(batchNo).append("\" xmlns=\"http://ws.cmctos.com.my/ctosnet/request\">").append("\r\n");
		sb.append("<company_code>").append(companyCode).append("</company_code>").append("\r\n");
		sb.append("<account_no>").append(accountNo).append("</account_no>").append("\r\n");
		sb.append("<user_id>").append(userId).append("</user_id>").append("\r\n");
		sb.append("<record_total>1</record_total>" + "\r\n");
		sb.append("<records>" + "\r\n");
		sb.append("<type>I</type>" + "\r\n");// I-individual,C-company,B-business
		sb.append("<ic_lc>" + oldic + "</ic_lc>" + "\r\n");// Old IC number(for individual)
                												  // or local number(for company)
                												  // or blank for business
		sb.append("<nic_br>").append(nric).append("</nic_br>").append("\r\n");// New IC/Passport
        				                  // number for
        								  // individual, blank
        								  // for company,
        								  // business
        								  // registration
        								  // number for
        								  // business
		sb.append("<name>").append(customerName).append("</name>").append("\r\n");
		sb.append("<mphone_nos>" + "\r\n");
		sb.append("<mphone_no/>" + "\r\n");
		sb.append("</mphone_nos>" + "\r\n");
		sb.append("<ref_no/>" + "\r\n");// User's own reference or remark (for
										// example, order number)
		sb.append("<dist_code></dist_code>" + "\r\n");// User's own distribution
                        							    // code(e.g. branch,
                        							    // department)
		sb.append(
				"<purpose code=\"200\">Credit evaluation/account opening on subject/directors/shareholder with consent /due diligence on AMLA compliance</purpose>"
						+ "\r\n");

		// 3rd request by christine
		sb.append("<include_consent>1</include_consent>" + "\r\n");
		sb.append("<include_ctos>1</include_ctos>" + "\r\n");
		sb.append("<include_trex>1</include_trex>" + "\r\n");
		sb.append("<include_ccris sum=\"0\">1</include_ccris>" + "\r\n");
		sb.append("<include_dcheq>1</include_dcheq>" + "\r\n");
		sb.append("<include_fico>1</include_fico>" + "\r\n");
		sb.append("<include_ssm>0</include_ssm>" + "\r\n");

		sb.append("<confirm_entity>0</confirm_entity>" + "\r\n");
		sb.append("</records>" + "\r\n");
		sb.append("</batch>");

		return sb.toString();
	}
}
