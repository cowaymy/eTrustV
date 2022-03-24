/**
 *
 */
package com.coway.trust.biz.services.onLoan.vo;

import java.io.Serializable;

import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * @author HQIT-HUIDING
 * @date Feb 17, 2020
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class LoanOrderVO extends OrderVO implements Serializable{

	private static final long serialVersionUID = 1L;

	private LoanOrderMVO loanOrderMVO; // Loan Order Master
	private LoanOrderDVO loanOrderDVO; // Loan Order Details

	public LoanOrderMVO getLoanOrderMVO() {
		return loanOrderMVO;
	}
	public void setLoanOrderMVO(LoanOrderMVO loanOrderMVO) {
		this.loanOrderMVO = loanOrderMVO;
	}
	public LoanOrderDVO getLoanOrderDVO() {
		return loanOrderDVO;
	}
	public void setLoanOrderDVO(LoanOrderDVO loanOrderDVO) {
		this.loanOrderDVO = loanOrderDVO;
	}


}
