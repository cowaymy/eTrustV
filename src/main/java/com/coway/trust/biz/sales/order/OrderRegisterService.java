/**
 *
 */
package com.coway.trust.biz.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface OrderRegisterService {

	EgovMap selectSrvCntcInfo(Map<String, Object> params);

	EgovMap selectStockPrice(Map<String, Object> params);

	List<EgovMap> selectDocSubmissionList(Map<String, Object> params);

	List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params);

	List<EgovMap> selectPromotionByAppTypeStock2(Map<String, Object> params);

	EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> params);

	EgovMap selectTrialNo(Map<String, Object> params);

	EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

	List<EgovMap> selectMemberList(Map<String, Object> params);

	public void registerOrder(OrderVO orderVO, SessionVO sessionVO) throws ParseException;

	EgovMap checkOldOrderId(Map<String, Object> params);

	EgovMap selectLoginInfo(Map<String, Object> params);

	EgovMap selectCheckAccessRight(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> selectProductCodeList(Map<String, Object> params);

	List<EgovMap> selectServicePackageList(Map<String, Object> params);

	List<EgovMap> selectServicePackageList2(Map<String, Object> params);

	List<EgovMap> selectPrevOrderNoList(Map<String, Object> params);

	EgovMap selectOldOrderId(Map<String, Object> params);

}
