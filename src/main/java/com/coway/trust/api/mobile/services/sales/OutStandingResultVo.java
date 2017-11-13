package com.coway.trust.api.mobile.services.sales;

import java.io.Serializable;
import java.util.List;

import io.swagger.annotations.ApiModelProperty;

public class OutStandingResultVo implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@ApiModelProperty(value = "RPF 총 금액")
	private int sumRpf = 0;
	
	@ApiModelProperty(value = "RPT 총 금액")
	private int sumRpt = 0;
	
	@ApiModelProperty(value = "RHF 총 금액")
	private int sumRhf = 0;
	
	@ApiModelProperty(value = "RENTAL 총 금액")
	private int sumRental = 0;
	
	@ApiModelProperty(value = "ADJUST 총 금액")
	private int sumAdjust = 0;
	
	@ApiModelProperty(value = "Outstanding Result Detail")
	private List<OutStandignResultDetail> osrd;

	public int getSumRpf() {
		return sumRpf;
	}

	public void setSumRpf(int sumRpf) {
		this.sumRpf = sumRpf;
	}

	public int getSumRpt() {
		return sumRpt;
	}

	public void setSumRpt(int sumRpt) {
		this.sumRpt = sumRpt;
	}

	public int getSumRhf() {
		return sumRhf;
	}

	public void setSumRhf(int sumRhf) {
		this.sumRhf = sumRhf;
	}

	public int getSumRental() {
		return sumRental;
	}

	public void setSumRental(int sumRental) {
		this.sumRental = sumRental;
	}

	public int getSumAdjust() {
		return sumAdjust;
	}

	public void setSumAdjust(int sumAdjust) {
		this.sumAdjust = sumAdjust;
	}

	public List<OutStandignResultDetail> getOsrd() {
		return osrd;
	}

	public void setOsrd(List<OutStandignResultDetail> osrd) {
		this.osrd = osrd;
	}
	
}
