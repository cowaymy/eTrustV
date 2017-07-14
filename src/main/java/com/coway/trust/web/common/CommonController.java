package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.DatabaseDrivenMessageSource;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class CommonController {

	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private DatabaseDrivenMessageSource dbMessageSource;
	
	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = commonService.selectCodeList(params);
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/generalCode.do")
	public String listCommCode(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "/common/generalCodeManagement";
	}
	
	@RequestMapping(value = "/selectMstCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeMstList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("commCodeMstId : {}", params.get("mstCdId"));

		List<EgovMap> mstCommCodeList = commonService.getMstCommonCodeList(params);
		
		return ResponseEntity.ok(mstCommCodeList);

	}
	
	@RequestMapping(value = "/selectDetailCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeDetailList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("commDetailDisabled : {}", params.get("mstDisabled"));
		logger.debug("commDetailCodeMstId : {}", params.get("mstCdId"));
		logger.debug("commDetailDisabled : {}", params.get("dtailDisabled"));
		
		List<EgovMap> mstCommDetailCodeList = commonService.getDetailCommonCodeList(params);
		
		return ResponseEntity.ok(mstCommDetailCodeList);
		
	}

	@RequestMapping(value = "/unauthorized.do")
	public String unauthorized(@RequestParam Map<String, Object> params, ModelMap model) {
		return "/error/unauthorized";
	}

	@RequestMapping(value = "/db-messages/reload.do")
	public void reload(@RequestParam Map<String, Object> params, ModelMap model) {
		dbMessageSource.reload();
	}
	
	@RequestMapping(value = "/saveGeneralCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommissionGrid(@RequestBody Map<String, ArrayList<Object>> params,	Model model) 
	{
		List<Object> udtList = params.get(AppConstants.AUIGrid_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
					// 조회.
			int cnt=0;
			if(addList.size()>0)
			{
				cnt=commonService.addCommCodeGrid(addList);
			}
			if(udtList.size()>0)
			{   
				cnt=commonService.udtCommCodeGrid(udtList);
			}
/*			if(delList.size()>0)
			{
				cnt=commonService.delCommCodeGrid(delList);
			}*/


		// 콘솔로 찍어보기
		logger.info("CommCd_수정 : {}", udtList.toString());
		logger.info("CommCd_추가 : {}", addList.toString());
		logger.info("CommCd_삭제 : {}", delList.toString());
		logger.info("CommCd_카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}	
	
	@RequestMapping(value = "/saveDetailCommCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommDetailGrid(@RequestBody Map<String, ArrayList<Object>> params,	Model model) 
	{
		List<Object> udtList = params.get(AppConstants.AUIGrid_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList
		
		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		// 조회.
		int cnt=0;
		if(addList.size()>0)
		{
			cnt=commonService.addDetailCommCodeGrid(addList);
		}
		if(udtList.size()>0)
		{   
			cnt=commonService.udtDetailCommCodeGrid(udtList);
		}
		/*			if(delList.size()>0)
			{
				cnt=commonService.delCommCodeGrid(delList);
			}
		*/

		// 콘솔로 찍어보기
		logger.info("DetailCommCd_수정 : {}", udtList.toString());
		logger.info("DetailCommCd_추가 : {}", addList.toString());
		logger.info("DetailCommCd_삭제 : {}", delList.toString());
		logger.info("DetailCommCd_카운트 : {}", cnt);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}	
	
	/**
	 * Use Map and Edit Grid Insert,Update,Delete
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
/*	@RequestMapping(value = "/saveGeneralCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveGeneralCodeGrid2222(@RequestBody Map<String, Object> params,	Model model) 
	{
		SessionVO sessionVO =  new SessionVO(); //sessionHandler.getCurrentSessionInfo();
		sessionVO.setId("7777");
		params.put(AppConstants.SESSION_INFO, sessionVO);
		commonService.saveCodes(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}	*/
	
	
}
