package com.coway.trust.common;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

public class SysTest {

	@Test
	public void JacksonTest() {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true);
//		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.UPPER_CAMEL_CASE);
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
