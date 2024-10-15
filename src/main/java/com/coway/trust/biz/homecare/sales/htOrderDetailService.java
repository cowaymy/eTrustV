/**
 *
 */
package com.coway.trust.biz.homecare.sales;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Tommy
 *
 */
public interface htOrderDetailService {

	public EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public List<EgovMap> selectCallLogList(Map<String, Object> params);

	public List<EgovMap> selectSameRentalGrpOrderList(Map<String, Object> params);

	public List<EgovMap> selectMembershipInfoList(Map<String, Object> params);

	public List<EgovMap> selectDocumentList(Map<String, Object> params);

	List<EgovMap> selectPaymentMasterList(Map<String, Object> params);

	List<EgovMap> selectAutoDebitList(Map<String, Object> params);

	List<EgovMap> selectDiscountList(Map<String, Object> params);

	List<EgovMap> selectLast6MonthTransList(Map<String, Object> params);

	List<EgovMap> selectLast6MonthTransListNew(Map<String, Object> params);

	EgovMap selectBasicInfo(Map<String, Object> params) throws Exception;

	EgovMap selectGSTCertInfo(Map<String, Object> params);

	List<EgovMap> selectEcashList(Map<String, Object> params);

	EgovMap selectCurrentBSResultByBSNo(Map<String, Object> params);

	List<EgovMap> selectASInfoList(Map<String, Object> params);

	List<EgovMap> selectCovrgAreaList(Map<String, Object> params);

	EgovMap getHTCovrgAreaList(Map<String, Object> params);

	public Map<String, Object> updateCovrgAreaStatus(Map<String, Object> params);

	List<EgovMap> selectCovrgAreaListByGrp(Map<String, Object> params);

	int updateCoverageAreaActive(Map<String, Object> params, SessionVO sessionVO);

	int updateCoverageAreaInactive(Map<String, Object> params, SessionVO sessionVO);

	ReturnMessage requestCancelCSOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception ;

	int updateCSOrderStatus(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> selectResnCodeList(Map<String, Object> params);

	List<EgovMap> selectHcAcBulkOrderDtlList(Map<String, Object> params);

}
