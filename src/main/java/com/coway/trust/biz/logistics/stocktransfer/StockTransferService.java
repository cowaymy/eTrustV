package com.coway.trust.biz.logistics.stocktransfer;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockTransferService {
	List<EgovMap> selectStockTransferMainList(Map<String, Object> params);

	List<EgovMap> selectStockTransferDeliveryList(Map<String, Object> params);

	String insertStockTransferInfo(Map<String, Object> params);

	List<EgovMap> addStockTransferInfo(Map<String, Object> params);

	List<EgovMap> selectStockTransferNoList(Map<String, Object> params);

	Map<String, Object> StocktransferDataDetail(String param);

	int stockTransferItemDeliveryQty(Map<String, Object> params);

	List<EgovMap> selectTolocationItemList(Map<String, Object> params);

	void deliveryStockTransferInfo(Map<String, Object> params);

	void deliveryStockTransferItmDel(Map<String, Object> params);

	String StocktransferReqDelivery(Map<String, Object> params);

	String StockTransferDeliveryIssue(Map<String, Object> params) throws Exception;

	List<EgovMap> selectStockTransferMtrDocInfoList(Map<String, Object> params);

	void insertStockBooking(Map<String, Object> params);

	void StocktransferDeliveryDelete(Map<String, Object> params);

	void deleteStoNo(Map<String, Object> param);

	int selectDelNo(Map<String, Object> param);

	String selectMaxQtyCheck(Map<String, Object> param);

	Map<String, Object> selectDelvryGRcmplt(String delyno);

	String defLoc(Map<String, Object> param);

	String selectDefLocation(Map<String, Object> params);

	public List<EgovMap> selectStoIssuePop(Map<String, Object> params) throws Exception;
	public String StockTransferDeliveryIssueNew(Map<String, Object> params, SessionVO sessionVo) throws Exception;

	/**
	 * Search Good Receipt Popup List
	 * @Author KR-SH
	 * @Date 2019. 12. 5.
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> goodReceiptPopList(Map<String, Object> params) throws Exception;

	/**
	 * Save Good Receipt Popup List
	 * @Author KR-SH
	 * @Date 2019. 12. 6.
	 * @param params
	 * @return
	 */
	public ReturnMessage StockTransferDeliveryIssueSerial(Map<String, Object> params, SessionVO sessionVo) throws Exception;

}
