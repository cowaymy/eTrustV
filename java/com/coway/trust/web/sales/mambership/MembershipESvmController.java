package com.coway.trust.web.sales.mambership;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.mambership.MembershipConvSaleService;
import com.coway.trust.biz.sales.mambership.MembershipESvmApplication;
import com.coway.trust.biz.sales.mambership.MembershipESvmService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/sales/membership")
public class MembershipESvmController {

	private static final Logger logger = LoggerFactory.getLogger(MembershipESvmController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
    @Autowired
    private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "membershipESvmService")
	private MembershipESvmService membershipESvmService;

	@Resource(name = "membershipConvSaleService")
	private MembershipConvSaleService membershipConvSaleService;

	@Autowired
	private MembershipESvmApplication membershipESvmApplication;

	@RequestMapping(value = "/membershipESvmList.do")
	public String membershipESvmList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		return "sales/membership/membershipESvmList";
	}

	@RequestMapping(value = "/selectESvmListAjax.do")
	public ResponseEntity<List<EgovMap>> selectESvmListAjax(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		logger.info("#############################################");
		logger.info("#############selectESvmListAjax Start");
		logger.info("############# params : " + params.get("ordNo"));
		logger.info("#############################################");
		//Params Setting
		String[] arrESvmStusId = request.getParameterValues("_stusId");    //Pre-Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("_brnchId");   //Key-In Branch
		String[] arrCustType     = request.getParameterValues("_typeId");    //Customer Type
		String[] arrESvmStusProgressId = request.getParameterValues("_stusProgressId");    //Status Progress

		if(arrESvmStusId != null && !CommonUtils.containsEmpty(arrESvmStusId)) params.put("arrESvmStusId", arrESvmStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrCustType     != null && !CommonUtils.containsEmpty(arrCustType))     params.put("arrCustType", arrCustType);
		if(arrESvmStusProgressId != null && !CommonUtils.containsEmpty(arrESvmStusProgressId)) params.put("arrESvmStusProgressId", arrESvmStusProgressId);

	  logger.info("############# params : " + params);

		List<EgovMap> result = membershipESvmService.selectESvmListAjax(params);

		return ResponseEntity.ok(result);

	}

  @RequestMapping(value = "/eSvmRawPop.do")
  public String hsCountForecastListingPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "sales/membership/eSvmRawPop";
  }

	@RequestMapping(value = "/membershipESvmDetailPop.do")
	public String membershipESvmDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap result = membershipESvmService.selectESvmInfo(params);
		EgovMap preSalesInfo = membershipESvmService.selectESvmPreSalesInfo(params);
		EgovMap paymentInfo = membershipESvmService.selectESvmPaymentInfo(params);
		EgovMap quotInfo = membershipESvmService.selectMembershipQuotInfo(params);
		params.put("action", result.get("stus"));
		List<EgovMap> specialInstruction = membershipESvmService.selectActionOption(params);
		List<EgovMap> payment_cardMode = membershipESvmService.selectCardMode(params);
		List<EgovMap> payment_issuedBank = membershipESvmService.selectIssuedBank(params);
		List<EgovMap> payment_cardType = membershipESvmService.selectCardType(params);
		List<EgovMap> payment_merchantBank = membershipESvmService.selectMerchantBank(params);

		model.put("eSvmInfo", result);
		model.put("preSalesInfo", preSalesInfo);
		model.put("paymentInfo", paymentInfo);
		model.put("quotInfo", quotInfo);
		model.put("specialInstruction", specialInstruction);
		model.put("payment_cardMode", payment_cardMode);
		model.put("payment_issuedBank", payment_issuedBank);
		model.put("payment_cardType", payment_cardType);
		model.put("payment_merchantBank", payment_merchantBank);

		logger.debug("params: ===========================>" + params);
		logger.debug("eSvmInfo: ===========================>" + result);
		logger.debug("PreSalesInfo: ===========================>" + preSalesInfo);
		logger.debug("PaymentInfo: ===========================>" + paymentInfo);
		logger.debug("QuotationInfo: ===========================>" + quotInfo);

		return "sales/membership/membershipESvmDetailPop";
	}

	@RequestMapping(value = "/selectMemberByMemberID.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectMemberByMemberID(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = membershipESvmService.selectMemberByMemberID(params);
    	return ResponseEntity.ok(result);
    }

	@RequestMapping(value = "/selecteESvmAttachList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getESvmAttachList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> attachList = membershipESvmService.getESvmAttachList(params) ;

		return ResponseEntity.ok( attachList);
	}

	@RequestMapping(value = "/attachESvmFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachESvmFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		logger.debug("params =====================================>>  " + params);
		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "sales" + File.separator + "membership", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			logger.debug("list.size : {}", list.size());
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			membershipESvmApplication.updatePreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

			params.put("attachFiles", list);
			code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectActionOption.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectActionOption(@RequestParam Map<String, Object> params) {
		List<EgovMap> specialInstruction = membershipESvmService.selectActionOption(params);
		logger.debug("params: =====================>> " + params);
		return ResponseEntity.ok(specialInstruction);

	}

    @RequestMapping(value = "/updateAction.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage>updateAction(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        logger.debug("params =====================================>>  " + params);

        params.put("userId", sessionVO.getUserId());
        params.put("updator", sessionVO.getUserId());

        Map<String, Object> Result = membershipESvmService.updateSVM(params,sessionVO);

        //srvMemNo
        //payWorNo
        String payWorNo = "";
        ReturnMessage message = new ReturnMessage();

        payWorNo = membershipESvmService.getPayWorNo(Result);
        Result.put("payWorNo", payWorNo);

        if(Integer.parseInt(Result.get("updAct").toString()) > 0) {
            if(!"6506".equals(Result.get("payment_mode").toString())) {
                message.setCode(AppConstants.SUCCESS);
                message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
                message.setData(Result);
            } else {
                switch(Integer.parseInt(Result.get("resultVal").toString())) {
                case 0:
                    message.setCode(AppConstants.FAIL);
                    message.setMessage("<b>Failed to save. Duplicated PO.");
                    break;
                case 1:
                    message.setCode(AppConstants.SUCCESS);
                    message.setMessage("<b>Pre-Sales successfully converted to membership sales.");
                    break;
                case 2:
                    message.setCode(AppConstants.SUCCESS);
                    message.setMessage("<b>Pre-Sales status successfully updated.");
                    break;
                case 99:
                    message.setCode(AppConstants.FAIL);
                    message.setMessage("<b>Failed to generate invoice. Please try again later.</b>");
                    break;
                case 98:
                    message.setCode(AppConstants.FAIL);
                    message.setMessage("<b>Failed to convert to sales. Please try again later.</b>");
                    break;
                case 97:
                    message.setCode(AppConstants.FAIL);
                    message.setMessage("<b>Failed to save. Please try again later.</b>");
                    break;
                default:
                    message.setCode(AppConstants.FAIL);
                    message.setMessage("<b>Failed to save. Please try again later.</b>");
                    break;
                }
            }
        } else {
            message.setCode(AppConstants.FAIL);
            if(!params.get("errorMsg").toString().isEmpty()){
            	message.setMessage(params.get("errorMsg").toString());
            }else{
            	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
            }
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/isSARefNoExist.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> isSARefNoExist(@RequestParam Map<String, Object> params) {
		int count = membershipESvmService.isSARefNoExist(params);
		ReturnMessage message = new ReturnMessage();
		if(count == 0){
			message.setCode(AppConstants.SUCCESS);
		}else{
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);

	}

    @RequestMapping(value = "/selectFailRemark.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectFailRemark(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> result = membershipESvmService.selectFailRemark(params);
    	return ResponseEntity.ok(result);
    }

}
