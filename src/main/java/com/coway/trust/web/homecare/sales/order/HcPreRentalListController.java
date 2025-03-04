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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.biz.homecare.sales.order.HcPreRentalListService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import org.slf4j.Logger;
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
public class HcPreRentalListController {

	private static Logger logger = LoggerFactory.getLogger(HcPreRentalListController.class);

    @Resource(name = "hcPreRentalListService")
    private HcPreRentalListService hcPreRentalListService;

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
    @RequestMapping(value = "/hcPreRentalList.do")
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
        List<EgovMap> productList_1 = hcPreRentalListService.selectProductCodeList();

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

        return "homecare/sales/order/hcPreRentalList";
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
	@RequestMapping(value = "/selectHcPreRentalList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHcOrderList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		//String[] arrAppType       	= request.getParameterValues("appType"); 		// Application Type
		String[] arrOrdStusId      	= request.getParameterValues("ordStusId"); 		// Order Status
		String[] arrKeyinBrnchId 	= request.getParameterValues("keyinBrnchId"); // Key-In Branch
		String[] arrDscBrnchId 		= request.getParameterValues("dscBrnchId"); 	// DSC Branch
		//String[] arrRentStus 		= request.getParameterValues("rentStus"); 		// Rent Status
		String[] arrProd     = request.getParameterValues("productId");       // Product list
		//String[] arrDscCodeId2		= request.getParameterValues("dscCodeId"); 	// DSC Code

		//if(arrAppType     		!= null && !CommonUtils.containsEmpty(arrAppType))      	params.put("arrAppType", arrAppType);
		if(arrOrdStusId     	!= null && !CommonUtils.containsEmpty(arrOrdStusId))     	params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId 	!= null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) 	params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   	!= null && !CommonUtils.containsEmpty(arrDscBrnchId))    	params.put("arrDscBrnchId", arrDscBrnchId);
		//if(arrRentStus      	!= null && !CommonUtils.containsEmpty(arrRentStus))        	params.put("arrRentStus", arrRentStus);
		if(arrProd        != null && !CommonUtils.containsEmpty(arrProd))         params.put("arrProd", arrProd);
		//if(arrDscCodeId2        != null && !CommonUtils.containsEmpty(arrDscCodeId2))         params.put("arrDscCodeId2", arrDscCodeId2);

		if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
		    params.put("memType", sessionVO.getUserTypeId());
		    params.put("memlvl", sessionVO.getMemberLevel());
		}
		if(params.containsKey("salesmanCode")) {
            if(!"".equals(params.get("salesmanCode").toString())) {
                int memberID = hcPreRentalListService.getMemberID(params);
                params.put("memID", memberID);
            }
        }
		logger.debug("params ===========> " + params);
		// 데이터 리턴.
		return ResponseEntity.ok(hcPreRentalListService.selectHcPreRentalList(params));
	}

	@RequestMapping(value = "/selectPreRentalConvertServicePackageList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPreRentalConvertServicePackageList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = hcPreRentalListService.selectPreRentalConvertServicePackageList(params);
		return ResponseEntity.ok(codeList);
	}

    @RequestMapping(value = "/hcPreRentalConvertPop.do")
	public String hcPreRentalConvertPop(@RequestParam Map<String, Object> params, ModelMap model) {

    	EgovMap getPreRentalBasicInfo = hcPreRentalListService.getPreRentalBasicInfo(params);
    	model.put("basicInfo", getPreRentalBasicInfo);

		// code List
        params.clear();
        params.put("groupCode", 10);
        params.put("orderValue", "CODE_ID");
        params.put("codeIn", SalesConstants.APP_TYPE_CODE_RENTAL);
        List<EgovMap> codeList_10 = commonService.selectCodeList(params);
        params.clear();

        params.put("groupCode", 19);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_19 = commonService.selectCodeList(params);

        params.put("groupCode", 17);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_17 = commonService.selectCodeList(params);

        params.put("groupCode", 322);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_322 = commonService.selectCodeList(params);

    	String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
    				SalesConstants.DEFAULT_DATE_FORMAT1);
    	String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    	model.put("bfDay", bfDay);
    	model.put("toDay", toDay);

    	model.put("codeList_10", codeList_10);
    	model.put("codeList_17", codeList_17);
    	model.put("codeList_19", codeList_19);
    	model.put("codeList_322", codeList_322);
    	model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));
    	model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "homecare/sales/order/hcPreRentalConvertPop";
	}

	@RequestMapping(value = "/hcPreRentalConfmConvertDetailPop.do")
	public String hcCnfmOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "homecare/sales/order/hcPreRentalConfmConvertDetailPop";
	}

    @RequestMapping(value = "/convertPreRental.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> convertPreRental(@RequestBody OrderVO orderVO, SessionVO sessionVO) {

    	int orderNumber = hcPreRentalListService.convertPreRental(orderVO, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(orderNumber > 0){
        	message.setCode(AppConstants.SUCCESS);
            message.setMessage("Order Number : " + String.valueOf(orderNumber) + "<br /> Successfully converted.");
        }
        else{
        	message.setCode(AppConstants.FAIL);
            message.setMessage("Failed to convert order.");
        }

        return ResponseEntity.ok(message);
	}
}
