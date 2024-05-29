/**
 *
 */
package com.coway.trust.biz.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
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

  List<EgovMap> selectPromotionByAppTypeStockESales(Map<String, Object> params);

  EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> params);

  EgovMap selectTrialNo(Map<String, Object> params);

  EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

  EgovMap checkRC(Map<String, Object> params);

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

  List<EgovMap> selectProductComponent(Map<String, Object> params);

  List<EgovMap> selectPromoBsdCpnt(Map<String, Object> params);

  List<EgovMap> selectPromoBsdCpntESales(Map<String, Object> params);

  EgovMap checkOldOrderIdICare(Map<String, Object> params);

  EgovMap selectProductComponentDefaultKey(Map<String, Object> params);

  EgovMap selectEKeyinSofCheck(Map<String, Object> params);

  List<EgovMap> mailAddrViewHistoryAjax(Map<String, Object> params);

  List<EgovMap> instAddrViewHistoryAjax(Map<String, Object> params);

  int chkPromoCboMst(Map<String, Object> params);

  int chkCboBindOrdNo(Map<String, Object> params);

  List<EgovMap> selectComboOrderJsonList(Map<String, Object> params);

  List<EgovMap> selectComboOrderJsonList_2(Map<String, Object> params);

  int checkCboPromByOrdNo(Map<String, Object> params);

  EgovMap getOrdInfo(Map<String, Object> params);

  List<EgovMap> selectPrevMatOrderNoList(Map<String, Object> params);

  String selectPrevMatOrderAppTypeId(Map<String, Object> params);

  EgovMap selectShiIndexInfo(String params);

  EgovMap getExTradeConfig();

  EgovMap getCtgryCode(Map<String, Object> params);

  EgovMap checkPreBookSalesPerson(Map<String, Object> params);

  EgovMap checkPreBookConfigurationPerson(Map<String, Object> params);

  EgovMap checkOldOrderServiceExpiryMonth(Map<String, Object> params);

  ReturnMessage checkExtradeWithPromoOrder(Map<String, Object> params);
}
