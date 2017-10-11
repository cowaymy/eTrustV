package com.coway.trust.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;

import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.RestTemplateFactory;
import com.coway.trust.util.UUIDGenerator;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

public class SysTest {

	private static final Logger LOGGER = LoggerFactory.getLogger(SysTest.class);

	@Test
	public void smsGenSuiteTest() {
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

		String message = "RM0.00" + "test message";
		String mobileNo = "01133681677"; // 말레이시아 번호이어야 함.

		String smsUrl = "http://" + hostName + hostPath + "?" + "ClientID=" + strClientID + "&Username=" + strUserName
				+ "&Password=" + strPassword + "&Type=" + strType + "&Message=" + message + "&SenderID=" + strSenderID
				+ "&Phone=" + countryCode + mobileNo + "&MsgID=" + strMsgID;

		ResponseEntity<String> res = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);

		LOGGER.debug("getStatusCode : {}", res.getStatusCode());
		LOGGER.debug("getBody : {}", res.getBody());

		// [ response log ]
		// 2017-07-25 14:00:59,683 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
		// 2017-07-25 14:00:59,684 DEBUG [com.coway.trust.common.SysTest] getBody : no_route

		// 2017-09-28 13:50:15,119 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
		// 2017-09-28 13:50:15,121 DEBUG [com.coway.trust.common.SysTest] getBody : success
	}

	@Test
	public void smsBulkTest(){

		String toMobile = "0165420960"; // 말레이시아 번호이어야 함.   01133681677, 0165420960
		String token = "279BhJNk22i80c339b8kc8ac29";
		String userName = "coway";
		String password = "coway";
		String msg = "test message by MVGate...";
		String trId = UUIDGenerator.get();

		String smsUrl = "http://103.246.204.24/bulksms/v4/api/mt?to=6" + toMobile + "&token=" + token + "&username=" + userName
				+ "&password=" + password + "&code=coway&mt_from=63660&text=" + msg + "&lang=0&trid=" + trId;

		ResponseEntity<String> res = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);

		LOGGER.debug("getStatusCode : {}", res.getStatusCode());
		LOGGER.debug("getBody : {}", res.getBody());

//		2017-09-29 13:10:03,431 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
//		2017-09-29 13:10:03,431 DEBUG [com.coway.trust.common.SysTest] getBody : 000,812472eedc1be64e8d7b1e880932,f9c125f3ca8146ac9d4efac2c45daf63

		String response = res.getBody();
		String[] resArray = response.split(",");

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
}
