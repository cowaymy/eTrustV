package com.coway.trust.common;

import java.math.BigDecimal;
import java.util.List;

public class Staff {
	private String Name;
	private int Age;
	private String Position;
	private BigDecimal Salary;
	private List<String> Skills;

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public int getAge() {
		return Age;
	}

	public void setAge(int age) {
		Age = age;
	}

	public String getPosition() {
		return Position;
	}

	public void setPosition(String position) {
		Position = position;
	}

	public BigDecimal getSalary() {
		return Salary;
	}

	public void setSalary(BigDecimal salary) {
		Salary = salary;
	}

	public List<String> getSkills() {
		return Skills;
	}

	public void setSkills(List<String> skills) {
		Skills = skills;
	}

}
