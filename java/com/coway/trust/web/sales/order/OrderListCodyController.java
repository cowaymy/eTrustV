/**
 *
 */
package com.coway.trust.web.sales.order;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderListCodyController {

	private static Logger logger = LoggerFactory.getLogger(OrderListCodyController.class);

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	@Resource(name = "orderListService")
	private OrderListService orderListService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;


	@RequestMapping(value = "/orderListCody.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
		    params.put("userId", sessionVO.getUserId());
		    EgovMap result =  salesCommonService.getUserInfo(params);

		    model.put("memId", result.get("memId"));
		    model.put("memCode", result.get("memCode"));
		    model.put("orgCode", result.get("orgCode"));
		    model.put("grpCode", result.get("grpCode"));
		    model.put("deptCode", result.get("deptCode"));
		}

		return "sales/order/orderListCody";
	}

	@RequestMapping(value = "/selectOrderJsonListCody", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

logger.debug("params : {}", params);

        //Log down user search params
        StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
        requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/initSearchPayment.do/");
        accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status
		String[] orderIDList = new String[255];

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus     != null && !CommonUtils.containsEmpty(arrRentStus))     params.put("arrRentStus", arrRentStus);

		if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
		    params.put("memType", sessionVO.getUserTypeId());
		    params.put("memlvl", sessionVO.getMemberLevel());
		}

		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}

		logger.debug("!@##############################################################################");
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### ordDt : "+params.get("ordDt"));
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");


		List<EgovMap> orderList =null;

		/*****************************************
		 *
		 *****************************************/
		logger.debug("vaNo,{}", StringUtils.isEmpty(params.get("vaNo")));
		logger.debug("listContactNo,{}", StringUtils.isEmpty(params.get("contactNo")));
		logger.debug("listCustIc,{}", StringUtils.isEmpty(params.get("custIc")));
		logger.debug("listCustName,{}", StringUtils.isEmpty(params.get("custName")));
		logger.debug("listCrtUserId,{}", StringUtils.isEmpty(params.get("crtUserId")));

		// 20210310 - LaiKW - Added 2 steps searching by removal of installation sirim/serial search
		if(params.containsKey("sirimNo") || params.containsKey("serialNo")) {
		    if(!"".equals(params.get("sirimNo").toString()) || !"".equals(params.get("serialNo").toString())) {
		    	//29-12-2022 - Chou Jia Cheng - edited serial number to be able to view more than one result at a time
		    	List<EgovMap> ordID = orderListService.getSirimOrdID(params);
		    	orderIDList=new String[ordID.size()];
            	for (int i=0;i<ordID.size();i++){
            		orderIDList[i]=String.valueOf(ordID.get(i).get("salesOrdId"));
            	}
                params.put("ordId", orderIDList);
		    }
		}

        if(params.containsKey("salesmanCode")) {
            if(!"".equals(params.get("salesmanCode").toString())) {
                int memberID = orderListService.getMemberID(params);
                params.put("memID", memberID);
            }
        }

		//if  Customer  (NRIC / VANo / ContactNo/ NAME / CrtUserId )   not empty
		if( ! StringUtils.isEmpty(params.get("vaNo"))
					 ||! StringUtils.isEmpty(params.get("contactNo"))
					 ||! StringUtils.isEmpty(params.get("custIc"))
					 ||! StringUtils.isEmpty(params.get("custName"))
					 ||! StringUtils.isEmpty(params.get("crtUserId"))
					 ||! StringUtils.isEmpty(params.get("refNo"))
					 ||! StringUtils.isEmpty(params.get("poNo"))){

			String[] arrayCustId =null;

			try{
				 arrayCustId =this.getExtCustIdList(params);
				 params.put("arrayCustId", arrayCustId);

				 if(null !=arrayCustId  || arrayCustId.length>0){
					 orderList = orderListService.selectOrderListCody(params);
				 }

			}catch (NullPointerException  nex){
				throw new ApplicationException(AppConstants.FAIL, "no data found");

			}catch(Exception  e){
				throw new ApplicationException(AppConstants.FAIL, "Please key in the correct data");
			}

		}else{
			orderList = orderListService.selectOrderListCody(params);
		}


		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}

	/*****************************************
	 *
	 *
	 * vaNo   listContactNo  listCustIc  listCustName  listCustId listCrtUserId
	 * @return  sal0029d.CUST_ID
	 */
	public  String[]  getExtCustIdList( Map<String, Object> params ) throws Exception  {

	   	String[]  arrayCustId =null;

		logger.debug("getExtCustIdList in ......");
		logger.debug("params {}",params);


	   //get Cust_ID for sal0029d
		List<EgovMap> custIdList = null;
		custIdList = orderListService.getCustIdOfOrderList(params);

		if( null != custIdList  && custIdList.size() >0){
			//init
			arrayCustId = new String[custIdList.size()];

			for (int i=0;i<custIdList.size(); i++){
				EgovMap am=(EgovMap)custIdList.get(i);
				arrayCustId[i]=  ((BigDecimal) am.get("custId")).toString();
			}
		}

		logger.debug("custIdList {}" ,custIdList);
		logger.debug("getExtCustIdList  end ......");
		return arrayCustId;
  }

}
