package com.coway.trust.biz.api.vo.chatbotInbound;

import java.io.Serializable;

import com.coway.trust.biz.api.vo.SurveyCategoryDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class CustomerVO implements Serializable{
	private int custId;
	private String custName;
	private String custNric;
	private int custNation;
	private String custType;

	@SuppressWarnings("unchecked")
	public static CustomerVO create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CustomerVO.class);
	}

	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getCustNric() {
		return custNric;
	}
	public void setCustNric(String custNric) {
		this.custNric = custNric;
	}

	public int getCustNation() {
		return custNation;
	}
	public void setCustNation(int custNation) {
		this.custNation = custNation;
	}

	public String getCustType() {
		return custType;
	}
	public void setCustType(String custType) {
		this.custType = custType;
	}
}
