package com.coway.trust.biz.api.vo.procurement;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CostCenterInfoVO implements Serializable {	
	private int budgetPlanYear;
	private int budgetPlanMonth;
	private String costCentr;
	private String costCenterText;
	private String glAccCode;
	private String glAccDesc;
	private String budgetCode;
	private String budgetCodeText;
	private Double chngAmt;
	private String crtDt;
	private String updDt;
}
