package com.coway.trust.web.homecare.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
 * 2020. 05. 20.   MY-ONGHC Pass Product Listing back to Browse Screen
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderListController {

	private static Logger logger = LoggerFactory.getLogger(HcOrderListController.class);

    @Resource(name = "hcOrderListService")
    private HcOrderListService hcOrderListService;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "homecareCmService")
    private HomecareCmService homecareCmService;

    @Resource(name = "orderDetailService")
    private OrderDetailService orderDetailService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

    /**
     *  Order List Open
     *
     * @Author KR-SH
     * @Date 2019. 10. 24.
     * @param params
     * @param model
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "/hcOrderList.do")
    public String main(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {
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

        // Product
        List<EgovMap> productList_1 = hcOrderListService.selectProductCodeList();

        if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
		    params.put("userId", sessionVO.getUserId());
//		    EgovMap result =  hcOrderListService.getOrgDtls(params);
		    EgovMap result =  salesCommonService.getUserInfo(params);

		    model.put("memId", result.get("memId"));
		    model.put("memCode", result.get("memCode"));
		    model.put("orgCode", result.get("orgCode"));
		    model.put("grpCode", result.get("grpCode"));
		    model.put("deptCode", result.get("deptCode"));
		}

        model.put("bfDay", bfDay);
        model.put("toDay", toDay);
        model.put("fromDay", CommonUtils.getAddDay(toDay, -1, SalesConstants.DEFAULT_DATE_FORMAT1));

        model.put("codeList_10", codeList_10);
        model.put("branchCdList_1", branchCdList_1);
        model.put("categoryCdList", categoryCdList);
        model.put("productList_1", productList_1);

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
	public ResponseEntity<List<EgovMap>> selectHcOrderList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String[] arrAppType       	= request.getParameterValues("appType"); 		// Application Type
		String[] arrOrdStusId      	= request.getParameterValues("ordStusId"); 		// Order Status
		String[] arrKeyinBrnchId 	= request.getParameterValues("keyinBrnchId"); // Key-In Branch
		String[] arrDscBrnchId 		= request.getParameterValues("dscBrnchId"); 	// DSC Branch
		String[] arrRentStus 		= request.getParameterValues("rentStus"); 		// Rent Status
		String[] arrProd     = request.getParameterValues("productId");       // Product list
		String[] arrDscCodeId2		= request.getParameterValues("dscCodeId"); 	// DSC Code

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt",  CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")),  SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrAppType     		!= null && !CommonUtils.containsEmpty(arrAppType))      	params.put("arrAppType", arrAppType);
		if(arrOrdStusId     	!= null && !CommonUtils.containsEmpty(arrOrdStusId))     	params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId 	!= null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) 	params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   	!= null && !CommonUtils.containsEmpty(arrDscBrnchId))    	params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus      	!= null && !CommonUtils.containsEmpty(arrRentStus))        	params.put("arrRentStus", arrRentStus);
		if(arrProd        != null && !CommonUtils.containsEmpty(arrProd))         params.put("arrProd", arrProd);
		if(arrDscCodeId2        != null && !CommonUtils.containsEmpty(arrDscCodeId2))         params.put("arrDscCodeId2", arrDscCodeId2);

		if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
		    params.put("memType", sessionVO.getUserTypeId());
		    params.put("memlvl", sessionVO.getMemberLevel());
		}
		if(params.containsKey("salesmanCode")) {
            if(!"".equals(params.get("salesmanCode").toString())) {
                int memberID = hcOrderListService.getMemberID(params);
                params.put("memID", memberID);
            }
        }
		logger.debug("params ===========> " + params);
		// 데이터 리턴.
		return ResponseEntity.ok(hcOrderListService.selectHcOrderList(params));
	}

	@RequestMapping(value = "/hcOrderRentToOutrSimulPop.do")
	public String orderRentToOutrSimulPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {

		model.put("ordNo", params.get("ordNo"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3));

		//Report Param
		model.put("userName", session.getUserId());
		model.put("brnchCode", session.getBranchName());  //AS-IS Brnch Code

		return "homecare/sales/order/hcOrderRentToOutrSimulPop";
	}

	@RequestMapping(value = "/selectOrderSimulatorViewByOrderNo.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectOrderSimulatorViewByOrderNo(@RequestParam Map<String, Object> params) {
	    EgovMap rslt = hcOrderListService.selectOrderSimulatorViewByOrderNo(params);
	    return ResponseEntity.ok(rslt);
	  }

}
