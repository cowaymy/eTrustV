package com.coway.trust.api.mobile.services.sales;

import java.io.Serializable;
import java.util.List;

import io.swagger.annotations.ApiModelProperty;

public class OutStandingResultVo implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@ApiModelProperty(value = "RPF 총 금액")
	private String sumRpf;
	
	@ApiModelProperty(value = "RPT 총 금액")
	private String sumRpt;
	
	@ApiModelProperty(value = "RHF 총 금액")
	private String sumRhf;
	
	@ApiModelProperty(value = "RENTAL 총 금액")
	private String sumRental;
	
	@ApiModelProperty(value = "ADJUST 총 금액")
	private String sumAdjust;
	
	@ApiModelProperty(value = "Outstanding Result Detail")
	private List<OutStandignResultDetail> osrd;

	public String getSumRpf() {
		return sumRpf;
	}

	public void setSumRpf(String sumRpf) {
		this.sumRpf = sumRpf;
	}

	public String getSumRpt() {
		return sumRpt;
	}

	public void setSumRpt(String sumRpt) {
		this.sumRpt = sumRpt;
	}

	public String getSumRhf() {
		return sumRhf;
	}

	public void setSumRhf(String sumRhf) {
		this.sumRhf = sumRhf;
	}

	public String getSumRental() {
		return sumRental;
	}

	public void setSumRental(String sumRental) {
		this.sumRental = sumRental;
	}

	public String getSumAdjust() {
		return sumAdjust;
	}

	public void setSumAdjust(String sumAdjust) {
		this.sumAdjust = sumAdjust;
	}

	public List<OutStandignResultDetail> getOsrd() {
		return osrd;
	}

	public void setOsrd(List<OutStandignResultDetail> osrd) {
		this.osrd = osrd;
	}
	
}
