package com.coway.trust.biz.api.vo.procurement;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "CostCenterReqForm", description = "CostCenterReqForm")
public class CostCenterReqForm {
	private int budgetPlanYear;
	private int budgetPlanMonth;
	
	
	public int getBudgetPlanYear() {
		return budgetPlanYear;
	}
	public void setBudgetPlanYear(int budgetPlanYear) {
		this.budgetPlanYear = budgetPlanYear;
	}
	public int getBudgetPlanMonth() {
		return budgetPlanMonth;
	}
	public void setBudgetPlanMonth(int budgetPlanMonth) {
		this.budgetPlanMonth = budgetPlanMonth;
	}
}
