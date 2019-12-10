package com.coway.trust.biz.homecare.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
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

}
