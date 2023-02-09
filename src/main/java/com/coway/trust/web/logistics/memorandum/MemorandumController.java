/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.memorandum;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.logistics.memorandum.MemorandumService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/memorandum")
public class MemorandumController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "memosvc")
	private MemorandumService memo;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@RequestMapping(value = "/MemoList.do")
	public String stockTransferDeliveryList(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/Memorandum/memorandumList";
	}

	@RequestMapping(value = "/MemoUpload.do")
	public String MemoUpload(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/Memorandum/memoUpload";
	}

	@RequestMapping(value = "/memoSearchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectMemoList(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		params.put("userTypeId", sessionVO.getUserTypeId());

		List<EgovMap> list = memo.selectMemoRandumList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectDeptSearchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDeptSearchList() throws Exception {
		return ResponseEntity.ok(memo.selectDeptSearchList());
	}

	@RequestMapping(value = "/selectMemoType.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemoType() throws Exception {
		return ResponseEntity.ok(memo.selectMemoType());
	}


	@RequestMapping(value = "/memoDelete.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> memoDelete(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		memo.memoDelete(params);

		ReturnMessage msg = new ReturnMessage();
		msg.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/memoSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertMemoSave(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		params.put("userid", loginId);
		params.put("userMainDeptId", sessionVO.getUserMainDeptId());

		ReturnMessage msg = new ReturnMessage();

		Map<String, Object> data = memo.memoSave(params);
		msg.setData(data);

		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/attachFileMemberUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
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

		logger.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadMemoFiles(request, uploadDir,
				File.separator + "organization" + File.separator + "LoginPopUp", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		logger.debug("list.size : {}", list.size());

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

		}catch(ApplicationException e){

			err = e.getMessage();
			code = AppConstants.FAIL;

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.FAIL));

			return ResponseEntity.ok(message);
		}
	}

	@RequestMapping(value = "/memoHistSave", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> calSave(@RequestBody Map<String, Object> params) throws Exception{

		//Session
		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());
		params.put("userFullName", session.getUserFullname());
		params.put("userBranchId", session.getUserBranchId());

		memo.memoHistSave(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();

	    message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

}
