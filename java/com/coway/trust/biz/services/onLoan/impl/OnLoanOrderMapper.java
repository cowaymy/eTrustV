package com.coway.trust.biz.services.onLoan.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.services.onLoan.vo.LoanOrderDVO;
import com.coway.trust.biz.services.onLoan.vo.LoanOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * IHR On Loan Order SQL Mapper
 * @author HQIT-HUIDING
 * @date Feb 10, 2020
 *
 */
@Mapper("onLoanOrderMapper")
public interface OnLoanOrderMapper {
	List<EgovMap> selectLoanOrdList(Map<String, Object> params);

	List<EgovMap> getUserCodeList();

	List<EgovMap> getOrgCodeList(Map<String, Object> params);

	List<EgovMap> getGrpCodeList(Map<String, Object> params);

	List<EgovMap> getBankCodeList(Map<String, Object> params);

	String select_SeqCCR0006D(Map<String, Object> params);

	String select_SeqCCR0007D(Map<String, Object> params);

	void insert_CCR0006D(Map<String, Object> params);

	void insert_CCR0007D(Map<String, Object> params);

	int selectLoanAppType();

	int chkCrtAS(LoanOrderDVO loanOrderDVO);

	String selectDocNo(int docNoId);

	void insertLoanOrderMaster(LoanOrderMVO loanOrderMVO);

	void insertLoanOrderDetails(LoanOrderDVO loanOrderDVO);

	void updateCustBillId(LoanOrderMVO loanOrderMVO);

	int selectCallLogCodeLoan(String code);

	EgovMap selectBasicInfo(Map<String, Object> params); // basic info

	EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params); // Salesman Info

	EgovMap selectOrderMailingInfoByOrderID(Map<String, Object> params); // Mailing Info

	EgovMap selectOrderInstallationInfoByOrderID(Map<String, Object> params); // Installation Info

	EgovMap selectLoanOrdMaster(Map<String, Object> params); // select Loan Order Master info

	EgovMap selectLoanOrdDetail(Map<String, Object> params); // select Loan Order Detail info

}
