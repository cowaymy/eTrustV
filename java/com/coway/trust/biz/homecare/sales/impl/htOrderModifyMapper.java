/**
 *
 */
package com.coway.trust.biz.homecare.sales.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.CustBillMasterHistoryVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.ReferralVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Tommy
 *
 */
@Mapper("htOrderModifyMapper")
public interface htOrderModifyMapper {

	void updateSalesOrderM(Map<String, Object> params);

	void insertCustBillMasterHistory(CustBillMasterHistoryVO custBillMasterHistoryVO);

	void updateCustBillMaster(Map<String, Object> params);

	void updateCustAddId(Map<String, Object> params);

	void updateNric(Map<String, Object> params);

	EgovMap selectBillGroupByBillGroupID(Map<String, Object> params); //Bill Group Master

	List<EgovMap> selectBillGroupOrder(Map<String, Object> params); //Bill Group Master

	int selectNricCheckCnt(Map<String, Object> params);

	int selectNricCheckCnt2(Map<String, Object> params);

	EgovMap selectCustInfo(Map<String, Object> params); //

	EgovMap selectNricExist(Map<String, Object> params); //

	EgovMap selectInstRsltCount(Map<String, Object> params);

	EgovMap selectGSTZRLocationCount(Map<String, Object> params);

	EgovMap selectGSTZRLocationByAddrIdCount(Map<String, Object> params);

	void updateInstallInfo(Map<String, Object> params);

	void updateInstallUpdateInfo(Map<String, Object> params);

	void updatePaymentChannel(RentPaySetVO rentPaySetVO);

	void saveDocSubmission(DocSubmissionVO docSubmissionVO);

	void updateDocSubmissionDel(DocSubmissionVO docSubmissionVO);

	List<EgovMap> selectReferralList(Map<String, Object> params);

	List<EgovMap> selectStateCodeList(Map<String, Object> params);

	void insertReferral(ReferralVO referralVO);

	void updateReferral(ReferralVO referralVO);

	void updatePromoPriceInfo(SalesOrderMVO salesOrderMVO);

	void updateRental(SalesOrderMVO salesOrderMVO);

	void updateGSTEURCertificate(GSTEURCertificateVO gSTEURCertificateVO);

	void updateECashInfo(SalesOrderMVO salesOrderMVO);

	EgovMap getInstallDetail(Map<String, Object> params);

	List<EgovMap> selectEditTypeList(Map<String, Object> params);
}
