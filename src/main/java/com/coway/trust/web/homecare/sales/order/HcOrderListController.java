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

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderListController.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 17.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderListController {

    @Resource(name = "hcOrderListService")
    private HcOrderListService hcOrderListService;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "homecareCmService")
    private HomecareCmService homecareCmService;

    /**
     *  Order List Open
     *
     * @Author KR-SH
     * @Date 2019. 10. 24.
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/hcOrderList.do")
    public String main(@RequestParam Map<String, Object> params, ModelMap model) {
        String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
                SalesConstants.DEFAULT_DATE_FORMAT1);
        String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

        // code List
        params.clear();
        params.put("groupCode", 10);
        List<EgovMap> codeList_10 = commonService.selectCodeList(params);

        // BranchCodeList_1
        params.clear();
        params.put("groupCode", 1);
        List<EgovMap> branchCdList_1 = commonService.selectBranchList(params);

        // StatusCategory Code
        params.clear();
        params.put("selCategoryId", 5);
        params.put("parmDisab", 0);
        List<EgovMap> categoryCdList = commonService.selectStatusCategoryCodeList(params);

        model.put("bfDay", bfDay);
        model.put("toDay", toDay);

        model.put("codeList_10", codeList_10);
        model.put("branchCdList_1", branchCdList_1);
        model.put("categoryCdList", categoryCdList);

        return "homecare/sales/order/hcOrderList";
    }

	/**
	 * Search Homacare OrderList
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectHcOrderList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHcOrderList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] arrAppType       	= request.getParameterValues("appType"); 		// Application Type
		String[] arrOrdStusId      	= request.getParameterValues("ordStusId"); 		// Order Status
		String[] arrKeyinBrnchId 	= request.getParameterValues("keyinBrnchId"); // Key-In Branch
		String[] arrDscBrnchId 		= request.getParameterValues("dscBrnchId"); 	// DSC Branch
		String[] arrRentStus 		= request.getParameterValues("rentStus"); 		// Rent Status

    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt",  CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")),  SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrAppType     		!= null && !CommonUtils.containsEmpty(arrAppType))      	params.put("arrAppType", arrAppType);
		if(arrOrdStusId     	!= null && !CommonUtils.containsEmpty(arrOrdStusId))     	params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId 	!= null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) 	params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   	!= null && !CommonUtils.containsEmpty(arrDscBrnchId))    	params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus      	!= null && !CommonUtils.containsEmpty(arrRentStus))        	params.put("arrRentStus", arrRentStus);

		// 데이터 리턴.
		return ResponseEntity.ok(hcOrderListService.selectHcOrderList(params));
	}
}
