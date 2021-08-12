package com.coway.trust.web.homecare.sales.order;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.sales.order.HcOrderExchangeService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderExchangeController.java
 * @Description : Homecare Order Exchange Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderExchangeController {

	@Resource(name = "hcOrderExchangeService")
	private HcOrderExchangeService hcOrderExchangeService;

	/**
	 * Homecare Order Exchange List 초기화 화면
	 * @Author KR-SH
	 * @Date 2019. 10. 31.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderExchangeList.do")
	public String hcOrderExchangeList(@RequestParam Map<String, Object> params, ModelMap model) {
	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "homecare/sales/order/hcOrderExchangeList";
	}


	/**
	 * Homecare Order Exchange List 조회
	 * @Author KR-SH
	 * @Date 2019. 10. 31.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderExchangeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> hcOrderExchangeList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		String[] arrExcType   = request.getParameterValues("cmbExcType");
		String[] arrExcStatus = request.getParameterValues("cmbExcStatus");
		String[] arrAppType = request.getParameterValues("cmbAppType");		//Application Type

		params.put("arrExcType", arrExcType);
		params.put("arrExcStatus", arrExcStatus);
		params.put("arrAppType", arrAppType);

		List<EgovMap> orderExchangeList = hcOrderExchangeService.hcOrderExchangeList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderExchangeList);
	}
}
