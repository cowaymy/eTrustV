package com.coway.trust.biz.homecare.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderRegisterService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
public interface HcOrderRegisterService {

	/**
	 * Select Homecare Product List
	 * @Author KR-SH
	 * @Date 2019. 10. 18.
	 * @param params
	 * @return list
	 */
	public List<EgovMap> selectHcProductCodeList(Map<String, Object> params);

	/**
	 * Homecare Register Order
	 * @Author KR-SH
	 * @Date 2019. 10. 23.
	 * @param orderVO
	 * @param sessionVO
	 * @throws ParseException
	 */
	public void hcRegisterOrder(OrderVO orderVO, SessionVO sessionVO) throws ParseException;

	/**
	 * Check Product Size
	 * @Author KR-SH
	 * @Date 2019. 12. 16.
	 * @param params
	 * @return
	 */
	public boolean checkProductSize(Map<String, Object> params);

	/**
	 * Select Promotion By Frame
	 * @Author KR-SH
	 * @Date 2019. 12. 24.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectPromotionByFrame(@RequestParam Map<String, Object> params);

	 int chkPromoCboMst(Map<String, Object> params);

	List<EgovMap> selectHcAcComboOrderJsonList(Map<String, Object> params);

	List<EgovMap> selectHcAcComboOrderJsonList_2(Map<String, Object> params);

  int chkQtyCmbOrd(Map<String, Object> params);

  List<EgovMap> selectHcAcCmbOrderDtlList(Map<String, Object> params);

  List<EgovMap> selectPwpOrderNoList(Map<String, Object> params);

  EgovMap checkPwpOrderId(Map<String, Object> params) throws ParseException;

  List<EgovMap> selectSeda4PromoList(Map<String, Object> params);

/*  public String selectLastHcAcCmbOrderInfo(Map<String, Object> params);

  int chkHcAcCmbOrdStus(Map<String, Object> params); */
}
