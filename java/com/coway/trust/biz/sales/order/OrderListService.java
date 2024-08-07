/**
 *
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface OrderListService {
	List<EgovMap> selectOrderList(Map<String, Object> params);

	List<EgovMap> getApplicationTypeList(Map<String, Object> params);

	List<EgovMap> getUserCodeList();

	List<EgovMap> getOrgCodeList(Map<String, Object> params);

	List<EgovMap> getGrpCodeList(Map<String, Object> params);

	EgovMap getMemberOrgInfo(Map<String, Object> params);

	List<EgovMap> getBankCodeList(Map<String, Object> params);

	EgovMap selectInstallParam(Map<String, Object> params);

	List<EgovMap> selectProductReturnView(Map<String, Object> params);

	EgovMap getPReturnParam(Map<String, Object> params);

	EgovMap productReturnResult(Map<String, Object> params);

	void setPRFailJobRequest(Map<String, Object> params);

	EgovMap getPrCTInfo(Map<String, Object> params);

	int chkRcdTms (Map<String, Object> params);

	List<EgovMap> selectOrderListVRescue(Map<String, Object> params);

	// KR_HAN :
	EgovMap insertProductReturnResultSerial(Map<String, Object> params);

	// KR_HAN
	EgovMap productReturnResultSerial(Map<String, Object> params);

	// KR_HAN
	Map<String, Object> selectOrderSerial(Map<String, Object> params);

	// KR HAN : Save Serial No Modify
//	Map<String, Object> saveSerialNoModify(Map<String, Object> params);

	List<EgovMap> selectCboPckLinkOrdSub(Map<String, Object> params);

	List<EgovMap> selectCboPckLinkOrdSub2(Map<String, Object> params);

	//add by leo.ham
	List<EgovMap> getCustIdOfOrderList(Map<String, Object> params);

	List<EgovMap> selectOrderListCody(Map<String, Object> params);

	// 20210310 - LaiKW - Added 2 steps query before selectOrderList/selectOrderListCody
	List<EgovMap> getSirimOrdID(Map<String, Object> params);
	int getMemberID(Map<String, Object> params);

	void sendSms(Map<String, Object> smsList);

	int selectCustBillId(Map<String, Object> params);

	Map<String, Object> getOderOutsInfo(Map<String, Object> params);

	public EgovMap selectOrderId(Map<String, Object> params) throws Exception;

	EgovMap selectHeaderInfo(Map<String, Object> params);

	List<EgovMap> selectHistInfo(Map<String, Object> params);

	List<EgovMap> selectMatrixInfo(Map<String, Object> params);

	List<EgovMap> selectAccLinkInfo(Map<String, Object> params);
}
