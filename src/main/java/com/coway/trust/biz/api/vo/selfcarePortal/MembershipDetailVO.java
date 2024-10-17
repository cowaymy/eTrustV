package com.coway.trust.biz.api.vo.selfcarePortal;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class MembershipDetailVO
    implements Serializable
{
    private String membershipType;

    private String membershipStartDate;

    private String membershipExpiryDate;

    private Double membershipFee;

    private int membershipYear;

    private String isCharge;
    
	public String getMembershipType() {
		return membershipType;
	}

	public void setMembershipType(String membershipType) {
		this.membershipType = membershipType;
	}

	public String getMembershipStartDate() {
		return membershipStartDate;
	}

	public void setMembershipStartDate(String membershipStartDate) {
		this.membershipStartDate = membershipStartDate;
	}

	public String getMembershipExpiryDate() {
		return membershipExpiryDate;
	}

	public void setMembershipExpiryDate(String membershipExpiryDate) {
		this.membershipExpiryDate = membershipExpiryDate;
	}

	public Double getMembershipFee() {
		return membershipFee;
	}

	public void setMembershipFee(Double membershipFee) {
		this.membershipFee = membershipFee;
	}

	public int getMembershipYear() {
		return membershipYear;
	}

	public void setMembershipYear(int membershipYear) {
		this.membershipYear = membershipYear;
	}

	public String getIsCharge() {
		return isCharge;
	}

	public void setIsCharge(String isCharge) {
		this.isCharge = isCharge;
	}

	@SuppressWarnings("unchecked")
    public static MembershipDetailVO create( EgovMap detList )
    {
        // TODO Auto-generated method stub
        return BeanConverter.toBean( detList, MembershipDetailVO.class );
    }
}
