package com.coway.trust.common;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;

import com.coway.trust.util.RestTemplateFactory;
import com.coway.trust.util.UUIDGenerator;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

public class SysTest {

	private static final Logger logger = LoggerFactory.getLogger(SysTest.class);

	//@Test
	public void smsTest() {
		String HOST_NAME = "gensuite.genusis.com";
		String HOST_PATH = "/api/gateway.php";
		String strClientID = "coway";
		String strUserName = "system";
		String strPassword = "genusis_2015";
		String strType = "SMS";
		String strSenderID = "63839";
		String CountryCode = "6";//"6"   "82";
		String randoms = UUIDGenerator.get();
		String strMsgID = "";
		int VendorID = 2;

		String message = "RM0.00" + "test message";
		String mobileNo = "01091887015";

		String SMSUrl = "http://" + HOST_NAME + HOST_PATH + "?" + "ClientID=" + strClientID + "&Username=" + strUserName
				+ "&Password=" + strPassword + "&Type=" + strType + "&Message=" + message + "&SenderID=" + strSenderID
				+ "&Phone=" + CountryCode + mobileNo + "&MsgID=" + strMsgID;

		ResponseEntity<String> res = RestTemplateFactory.getInstance().getForEntity(SMSUrl, String.class);

		logger.debug("getStatusCode : {}", res.getStatusCode());
		logger.debug("getBody : {}", res.getBody());

//		[ response log ]
//		2017-07-25 14:00:59,683 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
//		2017-07-25 14:00:59,684 DEBUG [com.coway.trust.common.SysTest] getBody : no_route

	}

	@Test
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
			System.out.println(jsonInString);

			// Convert object to JSON string and pretty print
			jsonInString = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(staff);
			System.out.println(jsonInString);

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
}
