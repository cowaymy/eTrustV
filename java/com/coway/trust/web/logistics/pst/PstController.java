package com.coway.trust.web.logistics.pst;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.logistics.pointofsales.PointOfSalesService;
import com.coway.trust.biz.logistics.pst.PstService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/pst")
public class PstController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;
	
	
	@Value("${com.file.upload.path}")
	private String uploadDir;
	@Value("${web.resource.upload.file}")
	private String uploadDirWeb;

	@Resource(name = "pstService")
	private PstService pst;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;
	
	@Autowired
	private FileApplication fileApplication;

	@RequestMapping(value = "/pst.do")
	public String pstView(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/pst/pst";
	}
	
	
	@RequestMapping(value = "/PstSearchList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> PstSearchList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {

		String   pstno     = request.getParameter("pstRefNo");
		String[] pststatus = request.getParameterValues("pstStusIds");
		String   crtdtfr   = request.getParameter("createStDate");
		String   crtdtto   = request.getParameter("createEnDate");
		String   dealerid  = request.getParameter("pstDealerId");
		String   dealernm  = request.getParameter("dealerName");
		String   nricno    = request.getParameter("pstNric");
		String   dtype     = request.getParameter("cmbDealerType");
		String[] psttype   = request.getParameterValues("cmbPstType");
		String   custno    = request.getParameter("pstCustPo");
		String   pic       = request.getParameter("pInCharge");
		if (pststatus != null ){
			for (int i = 0 ; i < pststatus.length ; i ++){
				System.out.println( "pststatus :::::: " + pststatus[i]);
			}
		}
		if (psttype != null ){
			for (int i = 0 ; i < psttype.length ; i ++){
				System.out.println( "psttype :::::: " + psttype[i]);
			}
		}
		Map<String , Object> map = new HashMap();
		map.put("pstno"    , pstno    );
		map.put("pststatus", pststatus);
		map.put("crtdtfr"  , crtdtfr  );
		map.put("crtdtto"  , crtdtto  );
		map.put("dealerid" , dealerid );
		map.put("dealernm" , dealernm );
		map.put("nricno"   , nricno   );
		map.put("dtype"    , dtype    );
		map.put("psttype"  , psttype  );
		map.put("custno"   , custno   );
		map.put("pic"      , pic      );
		
		List<EgovMap> list = pst.PstSearchList(map);

		Map<String, Object> rmap = new HashMap();
		rmap.put("data", list);

		return ResponseEntity.ok(rmap);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/pstMovementReqDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> pstMovementReqDelivery(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) {
		int loginId = sessionVO.getUserId();
		params.put("userId", loginId);
		
		//reqst 만들기 
		pst.pstMovementReqDelivery(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		//message.setData(returnValue);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/sampletest.do", method = RequestMethod.GET)
	public String sampletest(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) {
		int loginId = sessionVO.getUserId();
		params.put("userId", loginId);
		
		//reqst 만들기 
		pst.testsample();

		// 결과 만들기 예.
		/*ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		//message.setData(returnValue);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
		*/
		return "";
	}
	
	@RequestMapping(value = "PstMaterialDocView.do", method = RequestMethod.GET)
	public ResponseEntity<Map> PstMaterialDocViewList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {
		
		
		logger.debug(" ::::: {}" , params);
		List<EgovMap> list = pst.PstMaterialDocViewList(params);

		Map<String, Object> rmap = new HashMap();
		rmap.put("data", list);

		return ResponseEntity.ok(rmap);
	}

	//KR OHK : PST Serial Popup
    @RequestMapping(value = "/pstIssuePop.do")
    public String pstIssuePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    	model.addAttribute("url", params);
        return "logistics/pst/pstIssuePop";
    }

    //KR OHK : PST Serial Check List
    @RequestMapping(value = "/selectPstIssuePop.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectPstIssuePop(@RequestBody Map<String, Object> params, Model model) throws Exception {
    	ReturnMessage result = new ReturnMessage();

        List<EgovMap> list = pst.selectPstIssuePop(params);

        result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());

		return ResponseEntity.ok(result);
    }

	// KR-OHK PST Serial Check save
	@RequestMapping(value = "/pstMovementReqDeliverySerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> pstMovementReqDeliverySerial(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) {
		int loginId = sessionVO.getUserId();
		params.put("userId", loginId);

		//reqst 만들기
		pst.pstMovementReqDeliverySerial(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		//message.setData(returnValue);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
