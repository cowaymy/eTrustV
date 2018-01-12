package com.coway.trust.common;

import static java.util.concurrent.TimeUnit.MINUTES;
import static org.junit.Assert.*;

import java.io.*;
import java.math.BigDecimal;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;

import com.coway.trust.biz.common.LargeExcelQuery;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.UUIDGenerator;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

public class SysTest {

	private static final Logger LOGGER = LoggerFactory.getLogger(SysTest.class);

	@Test
	public void smsGenSuiteTest() throws UnsupportedEncodingException {
		String hostName = "gensuite.genusis.com";
		String hostPath = "/api/gateway.php";
		String strClientID = "coway";
		String strUserName = "system";
		String strPassword = "genusis_2015";
		String strType = "SMS";
		String strSenderID = "63839";
		String countryCode = "6";// "6" "82";
		String randoms = UUIDGenerator.get();
		String strMsgID = "";
		int vendorID = 2;

		String message = "RM0.00" + "[gensuite]test message!@#$%";
		String mobileNo = "0165420960"; // 말레이시아 번호이어야 함.

		String smsUrl = "http://" + hostName + hostPath + "?" + "ClientID=" + strClientID + "&Username=" + strUserName
				+ "&Password=" + strPassword + "&Type=" + strType + "&Message=" + URLEncoder.encode(message, "UTF-8") + "&SenderID=" + strSenderID
				+ "&Phone=" + countryCode + mobileNo + "&MsgID=" + strMsgID;

		Client client = Client.create();
		WebResource webResource = client.resource(smsUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		String output = response.getEntity(String.class);

		LOGGER.debug("getStatusCode : {}", response.getStatus());
		LOGGER.debug("getBody : {}", output);

		// [ response log ]
		// 2017-07-25 14:00:59,683 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
		// 2017-07-25 14:00:59,684 DEBUG [com.coway.trust.common.SysTest] getBody : no_route

		// 2017-09-28 13:50:15,119 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
		// 2017-09-28 13:50:15,121 DEBUG [com.coway.trust.common.SysTest] getBody : success
	}

	@Test
	public void smsBulkTest() throws UnsupportedEncodingException {

		String toMobile = "0165420960"; // 말레이시아 번호이어야 함. 01133681677, 0165420960
		String token = "279BhJNk22i80c339b8kc8ac29";
		String userName = "coway";
		String password = "coway";
		String msg = "[MVGate]test message !@#$...";
		String trId = UUIDGenerator.get();

		String smsUrl = "http://103.246.204.24/bulksms/v4/api/mt?to=6" + toMobile + "&token=" + token + "&username="
				+ userName + "&password=" + password + "&code=coway&mt_from=63660&text=" + URLEncoder.encode(msg, "UTF-8") + "&lang=0&trid=" + trId;

		Client client = Client.create();
		WebResource webResource = client.resource(smsUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		String output = response.getEntity(String.class);

		LOGGER.debug("getStatusCode : {}", response.getStatus());
		LOGGER.debug("getBody : {}", output);

		// 2017-09-29 13:10:03,431 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
		// 2017-09-29 13:10:03,431 DEBUG [com.coway.trust.common.SysTest] getBody :
		// 000,812472eedc1be64e8d7b1e880932,f9c125f3ca8146ac9d4efac2c45daf63

		String[] resArray = output.split(",");

		String status = resArray[0];
		String resMsgId = resArray[1];
		String restrId = resArray[2];

	}

	// @Test
	public void JacksonTest() {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true);
		// mapper.setPropertyNamingStrategy(PropertyNamingStrategy.UPPER_CAMEL_CASE);
		Staff staff = createDummyObject();

		try {
			// Convert object to JSON string and save into a file directly
			// mapper.writeValue(new File("D:\\staff.json"), staff);

			// Convert object to JSON string
			String jsonInString = mapper.writeValueAsString(staff);
			LOGGER.debug("jsonInString : {}", jsonInString);

			// Convert object to JSON string and pretty print
			jsonInString = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(staff);
			LOGGER.debug("jsonInString : {}", jsonInString);

		} catch (JsonGenerationException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private Staff createDummyObject() {

		Staff staff = new Staff();

		staff.setName("mkyong");
		staff.setAge(33);
		staff.setPosition("Developer");
		staff.setSalary(new BigDecimal("7500"));

		List<String> skills = new ArrayList<>();
		skills.add("java");
		skills.add("python");

		staff.setSkills(skills);

		return staff;

	}

	@Test
	public void differDateTest() {
		LOGGER.debug("CommonUtils.getDiffDate : {}", CommonUtils.getDiffDate("20170724"));
	}

	@Test
	public void formatFileSizeTest() {
		LOGGER.debug(">>>>> {}", CommonUtils.formatFileSize(1024 * 1024 * 100));
	}

	@Test
	public void testParseWillTrimAndConvertToNull() throws Exception {
		String CSV_HEADER = "Name,MobileNo,Location";
		String CSV_ROW_1 = " abc,@@,australia"; // MobileNo is 3 whitespaces
		CSVParser parse = CSVFormat.DEFAULT.withFirstRecordAsHeader().withIgnoreSurroundingSpaces().withNullString("@@")
				.parse(new BufferedReader(new StringReader(CSV_HEADER + "\n" + CSV_ROW_1)));

		CSVRecord rec = parse.getRecords().get(0);
		assertEquals("abc", rec.get("Name"));
		assertNull(rec.get("MobileNo"));
		assertEquals("australia", rec.get("Location"));
	}

	@Test
	public void methodTest() {
		String fullQueryId = "com.coway.trust.biz.commission.calculation.impl.CommissionCalculationMapper.selectCMM0013T";
		String simpleQueryId = "selectCMM0013T";

		assertEquals(LargeExcelQuery.CMM0013T, LargeExcelQuery.get(getSimpleQueryId(fullQueryId)));
		assertEquals(simpleQueryId, getSimpleQueryId(fullQueryId));
		assertTrue(isNotLargeExcelQuery(fullQueryId));
	}

	private boolean isNotLargeExcelQuery(String fullQueryId) {
		return LargeExcelQuery.get(getSimpleQueryId(fullQueryId)) != null;
	}

	private String getSimpleQueryId(String fullQueryId) {
		if (fullQueryId.lastIndexOf(".") != -1 && fullQueryId.lastIndexOf(".") != 0)
			return fullQueryId.substring(fullQueryId.lastIndexOf(".") + 1);
		else
			return "";
	}

	@Test
	public void jndiConnectTest() {
		Hashtable<String, String> h = new Hashtable<String, String>(7);
		h.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");
		h.put(Context.PROVIDER_URL, "t3://etrustdev.my.coway.com:7001");// add ur url
		h.put(Context.SECURITY_PRINCIPAL, "weblogic");// add username
		h.put(Context.SECURITY_CREDENTIALS, "weblogic12!@");// add password

		// Bundle bundle;
		try {
			InitialContext ctx = new InitialContext(h);
			// DataSource dataSource = ((DataSource) ctx.lookup("etrust-jndi"));
			DataSource dataSource = ((DataSource) ctx.lookup("eTRUST_DEV"));

			// bundle = (Bundle) ctx.lookup(BUNDLE_JNDI_NAME);

		} catch (NamingException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void millisToMinutes() {
		int m = 5;
		LOGGER.debug("{} Minutes => {} millis", m, MINUTES.toMillis(m));
	}

	@Test
	public void queryStringParseTest() throws URISyntaxException {
		List<NameValuePair> params = URLEncodedUtils.parse(new URI("url?aaa=111&bbb=2222&ccc=333"), "UTF-8");

		LOGGER.debug("size : {}", params.size());
		for (NameValuePair nameValuePair : params) {
			LOGGER.debug("{} : {}", nameValuePair.getName(), nameValuePair.getValue());
		}
	}

	@Test
	public void test() throws UnsupportedEncodingException {
		String str = URLEncoder.encode("RM0.00 "
				+ "Coway^ : PERINGATAN TERAKHIR: Sila bayar tunggakan RM780 dgn JomPAY (code 9928/Ref-1-10965515) utk mengelakkan nama anda disenaraihitamkan oleh semua Bank. ")
				.replaceAll("\\+", " ").replaceAll("%40", "@").replaceAll("%21", "!").replaceAll("%23", "#")
				.replaceAll("%24", "$").replaceAll("%3A", ":").replaceAll("%28", "(").replaceAll("%2F", "/")
				.replaceAll("%29", ")").replaceAll("%26", "&").replaceAll("%3C", "<").replaceAll("%60", "`")
				.replaceAll("%7E", "~").replaceAll("%24", "$").replaceAll("%5E", "^").replaceAll("%5F", "_")
				.replaceAll("%7B", "{").replaceAll("%7D", "}").replaceAll("%7C", "|").replaceAll("%5B", "[")
				.replaceAll("%5D", "]");
		LOGGER.debug(str);

		// ()-_=+:;'"~<>,.?
		// String deStr = URLDecoder.decode(str);
		// LOGGER.debug(deStr);
	}

	private String changeToHex(String value) {
		if (StringUtils.isEmpty(value)) {
			return "";
		}

		String returnValue = value;
		// returnValue = returnValue.replaceAll("&", "%26");
		// returnValue = returnValue.replaceAll("<", "%3C");
		// returnValue = returnValue.replaceAll("`", "%60");
		// returnValue = returnValue.replaceAll("~", "%7E");
		// returnValue = returnValue.replaceAll("$", "%24");
		// returnValue = returnValue.replaceAll("^", "%5E");
		// returnValue = returnValue.replaceAll("_", "%5F");
		// returnValue = returnValue.replaceAll("\\{", "%7B");
		// returnValue = returnValue.replaceAll("}", "%7D");
		// returnValue = returnValue.replaceAll("|", "%7C");
		// returnValue = returnValue.replaceAll("\\[", "%5B");
		// returnValue = returnValue.replaceAll("]", "%5D");
		returnValue = returnValue.replaceAll("//+", " ");
		return returnValue;
	}

	@Test
	public void testXSL() throws TransformerException {
		// StreamSource source = new StreamSource("d:\\str.xml"); // raw_data xml data

		// convert String into InputStream
		InputStream is = new ByteArrayInputStream(getRawData().getBytes());

		StreamSource source = new StreamSource(is); // raw_data xml data

		StreamSource stylesource = new StreamSource(
				"C:\\Users\\lim\\Desktop\\CTOS ENQWS v3.0.4_20161111\\3. Stylesheet\\ctos_report.xsl"); // xsl file...

		TransformerFactory factory = TransformerFactory.newInstance();
		Transformer transformer = factory.newTransformer(stylesource);

		StreamResult result = new StreamResult(new File("d:\\file.html")); // 최종파일.
		transformer.transform(source, result);
	}

	private String getRawData() {
		return "<report xmlns=\"http://ws.cmctos.com.my/ctosnet/response\" version=\"3.2.0\">\n"
				+ "   <enq_report id=\"BB-8540-20170511102227\" report_type=\"CTOS\" title=\"CTOS ENQUIRY\">\n"
				+ "      <header>\n" + "         <user id=\"b065000_xml\">COWAY (M) SDN BHD</user>\n"
				+ "         <company id=\"B065000\">COWAY (M) SDN BHD</company>\n"
				+ "         <account>B065000</account>\n" + "         <tel></tel>\n" + "         <fax></fax>\n"
				+ "         <enq_date>2017-05-11</enq_date>\n" + "         <enq_time>10:22:27</enq_time>\n"
				+ "         <enq_status code=\"1\">SUCCESS</enq_status>\n" + "      </header>\n" + "      <summary>\n"
				+ "         <enq_sum ptype=\"I\" pcode=\"\" seq=\"1\">\n"
				+ "            <name>NOR IZATE ILLIA BINTI ABDUL MANAS</name>\n" + "            <ic_lcno></ic_lcno>\n"
				+ "            <nic_brno>9.20905E+11</nic_brno>\n" + "            <stat>0000</stat>\n"
				+ "            <dd_index>0000</dd_index>\n" + "            <fico_index score=\"473\">\n"
				+ "               <fico_factor code=\"D8\">There is serious delinquency on the accounts, adverse record or collection filed on the credit report.</fico_factor>\n"
				+ "               <fico_factor code=\"E4\">Lack of recent account information on the credit report.</fico_factor>\n"
				+ "               <fico_factor code=\"K0\">Time since delinquency on the credit report is too short relative to the other applicants scored.</fico_factor>\n"
				+ "               <fico_factor code=\"M1\">Number of accounts with delinquency on the credit report is high relative to the other applicants scored.</fico_factor>\n"
				+ "            </fico_index>\n" + "            <mphone_nos></mphone_nos>\n"
				+ "            <ref_no></ref_no>\n" + "            <dist_code></dist_code>\n"
				+ "            <purpose code=\"200\">Credit evaluation/account opening on subject/directors/shareholder with consent /due diligence on AMLA compliance</purpose>\n"
				+ "            <include_consent>1</include_consent>\n" + "            <include_ctos>1</include_ctos>\n"
				+ "            <include_trex>1</include_trex>\n"
				+ "            <include_ccris sum=\"1\">1</include_ccris>\n"
				+ "            <include_dcheq>1</include_dcheq>\n" + "            <include_fico>1</include_fico>\n"
				+ "            <include_ssm>0</include_ssm>\n" + "            <confirm_entity>90007</confirm_entity>\n"
				+ "            <enq_status code=\"1\">SUCCESS</enq_status>\n"
				+ "            <enq_code code=\"4\">CTOS FICO Report</enq_code>\n" + "         </enq_sum>\n"
				+ "      </summary>\n" + "      <enquiry seq=\"1\">\n" + "         <section_summary>\n"
				+ "            <ctos>\n" + "               <bankruptcy status=\"0\"></bankruptcy>\n"
				+ "               <legal total=\"0\" value=\"0\"></legal>\n"
				+ "               <legal_personal_capacity total=\"0\" value=\"0\"></legal_personal_capacity>\n"
				+ "               <legal_non_personal_capacity total=\"0\" value=\"0\"></legal_non_personal_capacity>\n"
				+ "            </ctos>\n" + "            <tr>\n"
				+ "               <trex_ref negative=\"1\" positive=\"0\"></trex_ref>\n" + "            </tr>\n"
				+ "            <ccris>\n"
				+ "               <application total=\"0\" approved=\"0\" pending=\"0\"></application>\n"
				+ "               <facility total=\"0\" arrears=\"0\" value=\"0\"></facility>\n"
				+ "               <special_attention accounts=\"0\"></special_attention>\n" + "            </ccris>\n"
				+ "            <dcheqs entity=\"0\"></dcheqs>\n" + "         </section_summary>\n"
				+ "         <section_a data=\"false\" title=\"SECTION A - IDENTITY NUMBER VERIFICATION\"></section_a>\n"
				+ "         <section_b title=\"SECTION B - INTERNAL LIST\" data=\"true\">\n"
				+ "            <history seq=\"1\" rpttype=\"EH\" year=\"2017\">\n"
				+ "               <period month=\"1\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"2\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"3\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"1\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"4\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"5\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"1\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"6\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"7\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"8\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"9\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"10\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"11\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"12\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "            </history>\n" + "            <history seq=\"2\" rpttype=\"EH\" year=\"2016\">\n"
				+ "               <period month=\"1\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"2\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"3\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"4\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"5\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"6\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"7\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"8\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"9\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"10\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"11\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "               <period month=\"12\">\n"
				+ "                  <entity type=\"FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"NON-FI\" value=\"0\"></entity>\n"
				+ "                  <entity type=\"LAWYER\" value=\"0\"></entity>\n" + "               </period>\n"
				+ "            </history>\n" + "         </section_b>\n"
				+ "         <section_c title=\"SECTION C - DIRECTORSHIPS AND BUSINESS INTERESTS\" data=\"false\"></section_c>\n"
				+ "         <section_d title=\"SECTION D\" data=\"false\"></section_d>\n"
				+ "         <section_d2 title=\"SECTION D2 SUBJECT AS PLAINTIFF\" data=\"false\"></section_d2>\n"
				+ "         <section_ccris title=\"SECTION CCRIS\" data=\"false\"></section_ccris>\n"
				+ "         <section_dcheqs title=\"SECTION DCHEQ\" data=\"false\"></section_dcheqs>\n"
				+ "      </enquiry>\n" + "   </enq_report>\n" + "   <trex status=\"1\">\n" + "      <subject_request>\n"
				+ "         <party_type>I</party_type>\n" + "         <name>NOR IZATE ILLIA BINTI ABDUL MANAS</name>\n"
				+ "         <iclc></iclc>\n" + "         <nicbr>9.20905E+11</nicbr>\n"
				+ "         <date_requested>11-05-2017 10:18:46</date_requested>\n"
				+ "         <date_completed>11-05-2017 10:18:46</date_completed>\n"
				+ "         <requester_id></requester_id>\n" + "         <requester_name></requester_name>\n"
				+ "         <requester_comp_code>B065000</requester_comp_code>\n"
				+ "         <requester_account>B065000</requester_account>\n" + "      </subject_request>\n"
				+ "      <referee id=\"1\">\n" + "         <party_type>I</party_type>\n"
				+ "         <name>NOR IZATE ILLIA BINTI ABDUL MANAS</name>\n" + "         <iclc></iclc>\n"
				+ "         <nicbr>9.20905E+11</nicbr>\n" + "         <tref_id>7416613</tref_id>\n"
				+ "      </referee>\n" + "   </trex>\n"
				+ "   <tr_report preview=\"0\" type=\"TR\" title=\"Trade Reference\">\n" + "      <header>\n"
				+ "         <date>2017-05-11</date>\n" + "         <req_name>COWAY (M) SDN BHD</req_name>\n"
				+ "         <req_email></req_email>\n" + "         <req_com_name>COWAY (M) SDN BHD</req_com_name>\n"
				+ "         <req_com_addr></req_com_addr>\n"
				+ "         <ref_com_name>MAXIS BROADBAND SDN BHD : COLLECTION DEPT</ref_com_name>\n"
				+ "         <ref_email></ref_email>\n" + "         <ref_com_bus>FIXED PHONE LINE OPERATORS.  \n"
				+ "            PROVIDER OF MOBILE TELECOMMUNICATION PRODUCTS AND SERVICES\n"
				+ "         </ref_com_bus>\n" + "         <report_no>15263448</report_no>\n"
				+ "         <ic_lcno></ic_lcno>\n" + "         <nic_brno>9.20905E+11</nic_brno>\n"
				+ "         <name>JOEL BIN GOLUBI</name>\n" + "      </header>\n"
				+ "      <enquiry account_no=\"1652058395\">\n" + "         <section id=\"relationship\">\n"
				+ "            <data name=\"rel_type\">CUSTOMER</data>\n"
				+ "            <data name=\"rel_status\">Defaulter</data>\n"
				+ "            <data name=\"account_no\">1652058395</data>\n"
				+ "            <data name=\"rel_syear\">2000</data>\n"
				+ "            <data name=\"rel_smonth\"></data>\n" + "            <data name=\"rel_sday\"></data>\n"
				+ "         </section>\n" + "         <section id=\"sponsor\"></section>\n"
				+ "         <section id=\"account_status\">\n"
				+ "            <data name=\"account_no\">1652058395</data>\n"
				+ "            <data name=\"statement_date\">2017-02-14</data>\n"
				+ "            <data name=\"account_rating\">4</data>\n"
				+ "            <data name=\"account_term\">0</data>\n"
				+ "            <data name=\"account_limit\">0</data>\n"
				+ "            <data name=\"account_status\">Defaulter</data>\n"
				+ "            <data name=\"debtor_name\">JOEL BIN GOLUBI</data>\n"
				+ "            <data name=\"debtor_ic_lcno\"></data>\n"
				+ "            <data name=\"debtor_nic_brno\">9.20905E+11</data>\n"
				+ "            <data name=\"address\"></data>\n"
				+ "            <data name=\"debt_type\">Dues outstanding</data>\n" + "            <data name=\"age\">\n"
				+ "               <item name=\"30\">0.00</item>\n" + "               <item name=\"60\">0.00</item>\n"
				+ "               <item name=\"90\">0.00</item>\n" + "               <item name=\"120\">0.00</item>\n"
				+ "               <item name=\"150\">0.00</item>\n" + "               <item name=\"180\">0.00</item>\n"
				+ "               <item name=\"210\">9857.00</item>\n" + "            </data>\n"
				+ "         </section>\n"
				+ "         <section id=\"return_cheque\" status=\"Not Provided\"></section>\n"
				+ "         <section id=\"legal_action\" status=\"Not Provided\"></section>\n"
				+ "         <section id=\"contact\">\n" + "            <data name=\"reference\">1652058395</data>\n"
				+ "            <data name=\"name\">1-800-820-043,03-74914588(09:00 till 18:00)</data>\n"
				+ "            <data name=\"address\"></data>\n" + "            <data name=\"tel_no\"></data>\n"
				+ "            <data name=\"fax_no\">03-74910219</data>\n"
				+ "            <data name=\"email\"></data>\n" + "            <data name=\"type_code\">1</data>\n"
				+ "            <data name=\"type_desc\">Please call us at our contact below.</data>\n"
				+ "         </section>\n" + "      </enquiry>\n" + "   </tr_report>\n" + "</report>";
	}
}
