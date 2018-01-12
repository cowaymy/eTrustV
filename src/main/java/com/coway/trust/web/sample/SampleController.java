package com.coway.trust.web.sample;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.function.Consumer;

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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.application.SampleApplication;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.*;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
import com.coway.trust.util.UUIDGenerator;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sample")
public class SampleController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleController.class);

	@Resource(name = "sampleService")
	private SampleService sampleService;

	// 멀티 서비스 이용시 업무 + Application 에서 공통으로 사용되는 서비스를 구현한다.
	@Autowired
	private SampleApplication sampleApplication;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Value("${batch.jar.dir}")
	private String batchDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileApplication fileApplication;

	@Autowired
	private AdaptorService adaptorService;

	// @RequestMapping(value = "/barcode.do")
	// public void barcode(HttpServletRequest request, HttpServletResponse response) throws Exception {
	//
	// try {
	//
	// String data = request.getParameter("DATA");
	// String type = request.getParameter("TYPE");
	//
	// Code128 barcode = new Code128();
	// barcode.setData(data);
	//
	// ServletOutputStream servletoutputstream = response.getOutputStream();
	//
	// response.setContentType("image/jpeg");
	// response.setHeader("Pragma", "no-cache");
	// response.setHeader("Cache-Control", "no-cache");
	// response.setDateHeader("Expires", 0);
	//
	// // Generate Code-128 barcode & output to ServletOutputStream
	// barcode.drawBarcode(servletoutputstream);
	//
	// } catch (Exception e) {
	// throw new ApplicationException(e);
	// }
	// }

	/**
	 * batch excute sample.....
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/batchExcute.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> batchExcute() throws Exception {

		ProcessBuilder builder = new ProcessBuilder();
		List<String> command = new ArrayList<>();

		if (isWindows()) {
			setCommand(builder, command);
		} else {
			setCommand(builder, command);
		}
		builder.directory(new File(batchDir));
		Process process = builder.start();

		StreamGobbler streamGobbler = new StreamGobbler(process.getInputStream(), str -> LOGGER.debug("{}", str));
		Executors.newSingleThreadExecutor().submit(streamGobbler);
		// int exitCode = process.waitFor();

		return ResponseEntity.ok(new ReturnMessage());
	}

	private void setCommand(ProcessBuilder builder, List<String> command) {
		command.add("java");
		command.add("-jar");
		command.add("-Denv=local");
		command.add("-Dspring.profiles.active=local");
		command.add("batch-1.0.0-SNAPSHOT.jar");
		command.add("-Dspring.batch.job.names=ctosJob");
		command.add("ctosJob");
		command.add("aa=" + command);
		// command.add("--spring.batch.job.names=ctosJob");
		LOGGER.debug("command : {}", command.toString());
		builder.command(command);
	}

	private static class StreamGobbler implements Runnable {
		private InputStream inputStream;
		private Consumer<String> consumer;

		public StreamGobbler(InputStream inputStream, Consumer<String> consumer) {
			this.inputStream = inputStream;
			this.consumer = consumer;
		}

		@Override
		public void run() {
			new BufferedReader(new InputStreamReader(inputStream)).lines().forEach(consumer);
		}
	}

	private static boolean isWindows() {
		String osName = System.getProperty("os.name");
		return osName.contains("Windows");
	}

	@RequestMapping(value = "/sampleEmailSMS.do")
	public String sampleEmailSMS(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		return "sample/sampleEmailSMS";
	}

	@RequestMapping(value = "/sampleEditor.do")
	public String sampleEditor(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		return "sample/sampleEditor";
	}

	@RequestMapping(value = "/sampleSchedule.do")
	public String sampleSchedule(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		return "sample/sampleSchedule";
	}

	@RequestMapping(value = "/sampleSchedulePop.do")
	public String sampleSchedulePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		return "sample/sampleSchedulePop";
	}

	@RequestMapping(value = "/getEditor.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getEditor(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		List<EgovMap> list = sampleService.getEditor(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/saveEditor.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveEditor(@RequestBody Map<String, Object> params, Model model)
			throws Exception {
		ReturnMessage msg = new ReturnMessage();
		sampleService.saveEditor(params);
		msg.setData(params.get("memoId"));
		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/sendEmail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sendEmail(@RequestParam Map<String, Object> params, Model model) {
		ReturnMessage retMsg = new ReturnMessage();

		EmailVO email = new EmailVO();
		email.setTo("t1706036@partner.coway.co.kr");
		email.addTo("im7015@naver.com");
		email.setSubject("subject");

		// 일반 텍스트....
		// email.setHtml(false); // 본문 내용 html 여부
		// email.setText("email text");
		// boolean isSuccess = adaptorService.sendEmail(email, false);

		// 메일 템플릿 파라미터 예시....
		email.setHtml(true); // 본문 내용 html 여부
		params.put("attentionTo", "==attentionTo");
		params.put("orderNo", "==orderNo");
		params.put("totalOverdueAmount", "==totalOverdueAmount");
		params.put("product", "==product");
		params.put("virtualAccount", "==virtualAccount");
		params.put("billerCode", "==billerCode");
		params.put("ref", "==ref");

		boolean isSuccess = adaptorService.sendEmail(email, false, EmailTemplateType.OVERDUE_PAYMENT_4, params);

		retMsg.setMessage("isSuccess : " + isSuccess);

		return ResponseEntity.ok(retMsg);
	}

	@RequestMapping(value = "/genSuite/sendSMS.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> genSuiteSendSMS(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		ReturnMessage retMsg = new ReturnMessage();

		String hostName = "gensuite.genusis.com";
		String hostPath = "/api/gateway.php";
		String strClientID = "coway";
		String strUserName = "system";
		String strPassword = "genusis_2015";
		String strType = "SMS";
		String strSenderID = "63839";
		String countryCode = "6";// "6" "82";
		String randoms = UUIDGenerator.get();
		String strMsgID = "";
		int vendorID = 2;

		String message = "++OK test message by genSuite";
		String mobileNo = "01111922965";// 말레이시아 번호이어야 함. 01133681677, 0165420960

		if (CommonUtils.isNotEmpty(params.get("phone"))) {
			mobileNo = (String) params.get("phone");
		}

		if (CommonUtils.isNotEmpty(params.get("message"))) {
			message = (String) params.get("message");
		}

		params.put("userId", sessionVO.getUserId());
		params.put("mobileNo", mobileNo);
		params.put("smsMessage", message);

		SmsResult smsResult = sampleApplication.sendSmsAndProcess(params);
		retMsg.setMessage(
				"Success count : " + smsResult.getSuccessCount() + " ### getFailReason : " + smsResult.getFailReason());

		// String smsUrl = "http://" + hostName + hostPath + "?" + "ClientID=" + strClientID + "&Username=" +
		// strUserName
		// + "&Password=" + strPassword + "&Type=" + strType + "&Message=" + message + "&SenderID=" + strSenderID
		// + "&Phone=" + countryCode + mobileNo + "&MsgID=" + strMsgID;
		//
		// ResponseEntity<String> res = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);
		//
		// LOGGER.debug("getStatusCode : {}", res.getStatusCode());
		// LOGGER.debug("getBody : {}", res.getBody());
		//
		// retMsg.setMessage("getStatusCode : " + res.getStatusCode() + " :: getBody : " + res.getBody());

		return ResponseEntity.ok(retMsg);
	}

	@RequestMapping(value = "/mvgate/sendSMS.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> mvgateSendSMS(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		ReturnMessage retMsg = new ReturnMessage();

		String toMobile = "01111922965"; // 말레이시아 번호이어야 함. 01133681677, 0165420960

		if (CommonUtils.isNotEmpty(params.get("phone"))) {
			toMobile = (String) params.get("phone");
		}

		String token = "279BhJNk22i80c339b8kc8ac29";
		String userName = "coway";
		String password = "coway";
		String msg = "test message by MVGate...!@#$";
		String trId = UUIDGenerator.get();

		BulkSmsVO bulkSmsVO = new BulkSmsVO(sessionVO.getUserId(), 976);
		bulkSmsVO.setMobile(toMobile);
		bulkSmsVO.setMessage(msg);

		SmsResult smsResult = adaptorService.sendSMSByBulk(bulkSmsVO);
		retMsg.setMessage(
				"Success count : " + smsResult.getSuccessCount() + " ### getFailReason : " + smsResult.getFailReason());

		// String smsUrl = "http://103.246.204.24/bulksms/v4/api/mt?to=6" + toMobile + "&token=" + token + "&username="
		// + userName + "&password=" + password + "&code=coway&mt_from=63660&text=" + msg + "&lang=0&trid=" + trId;
		//
		// ResponseEntity<String> res = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);
		//
		// LOGGER.debug("getStatusCode : {}", res.getStatusCode());
		// LOGGER.debug("getBody : {}", res.getBody());

		// 2017-09-29 13:10:03,431 DEBUG [com.coway.trust.common.SysTest] getStatusCode : 200
		// 2017-09-29 13:10:03,431 DEBUG [com.coway.trust.common.SysTest] getBody :
		// 000,812472eedc1be64e8d7b1e880932,f9c125f3ca8146ac9d4efac2c45daf63

		// String response = res.getBody();
		// String[] resArray = response.split(",");
		//
		// String status = resArray[0];
		// String resMsgId = resArray[1];
		// String restrId = resArray[2];
		//
		// retMsg.setMessage("getStatusCode : " + res.getStatusCode() + " :: getBody : " + res.getBody());

		return ResponseEntity.ok(retMsg);
	}

	/**
	 * 트랜잭션 rollback 예제.
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveTransaction.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveTransaction(@RequestParam Map<String, Object> params, Model model)
			throws Exception {
		sampleService.saveTransaction(params);
		return ResponseEntity.ok(new ReturnMessage());
	}

	/**
	 * 화면 호출. - publish 적용. - 그리드 페이징 갯수 변경 처리 포함됨 : publishSample.jsp
	 */
	@RequestMapping(value = "/publishSample.do")
	public String publishSample(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		// 화면별 버튼 권한 리스트 예제.
		Map<String, Object> buttonMap = new HashMap<>();

		buttonMap.put("save", true);
		buttonMap.put("update", true);
		buttonMap.put("delete", true);

		model.addAttribute("auth", buttonMap);

		// 호출될 화면
		return "sample/publishSample";
	}

	@RequestMapping(value = "/sampleChart.do")
	public String sampleChart(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		// 챠트 예제.
		return "sample/sampleChart";
	}

	@RequestMapping(value = "/sampleLineChart.do")
	public String sampleLineChart(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		// 챠트 예제.
		return "sample/sampleLineChart";
	}

	@RequestMapping(value = "/getChartData.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getChartData(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		params.put("pYear", CommonUtils.nvl((String) params.get("pYear"), "2017"));

		List<EgovMap> list = sampleService.getChartData(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/getLineChartData.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getLineChartData(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		params.put("pYear", CommonUtils.nvl((String) params.get("pYear"), "2017"));

		List<EgovMap> list = sampleService.getLineChartData(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/sampleAuth.do")
	public String sampleAuth(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		// 화면별 버튼 권한 리스트 예제.
		return "sample/sampleAuth";
	}

	/**
	 * 서비스 + 메일 전송 예제. sendMail test.
	 */
	@RequestMapping(value = "/sendMail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sendMail(@RequestBody Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		boolean result = sampleApplication.sendEmailAndProcess(params);
		if (!result) {
			// TODO : 다국어 적용 필요.
			message.setDetailMessage("SMS  전송 실패하였습니다.");
		}
		return ResponseEntity.ok(message);
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleGridDown.do")
	public String sampleGridDown(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "sample/sampleGridDown";
	}

	/**
	 * 다중 서비스 호출 예제. - 마지막 서비스에서 오류 발생하여 모두 롤백됨.
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveMultiService.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMultiService(@RequestParam Map<String, Object> params, Model model)
			throws Exception {
		sampleApplication.saveMultiService(params);
		return ResponseEntity.ok(new ReturnMessage());
	}

	/**
	 * 다중 서비스 호출 예제. - 마지막 서비스에서 오류 발생하여도 무시하고 진행.
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveNoRollback.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveNoRollback(@RequestParam Map<String, Object> params, Model model)
			throws Exception {
		sampleService.saveNoRollback(params);
		return ResponseEntity.ok(new ReturnMessage());
	}

	/**
	 * clob 컬럼 조회 예제.
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectClobData.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectClobData(@RequestParam Map<String, Object> params, Model model,
			Date toDate) throws Exception {
		List<EgovMap> list = sampleService.selectClobData(params);
		// List<EgovMap> list2 = sampleService.selectClobOtherData(params);
		return ResponseEntity.ok(list);
	}

	/**
	 * responseBody에 json data로 응답을 보내는 경우.
	 * 
	 * 1) return type void 인 경우 : response body 로 보내려면, @ResponseBody 를 기술해 줌. 2) return type을 ResponseEntity
	 * <ReturnMessage> 로 하여 보내 준다. ( @ResponseBody 필요 없음 )
	 * 
	 * @param params
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveClobData.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveClobData(@RequestBody Map<String, Object> params, Model model) throws Exception {

		// sample date
		params.put("baseYear", "2019");
		params.put("baseWeek", "99");
		params.put("baseCdc", "TEST");
		params.put("requestComment", "TEST_REQUEST_COMMENT"); // clob

		sampleService.insertClobData(params);

		// return ResponseEntity.ok(new ReturnMessage());
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleView.do")
	public String sampleView(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		LOGGER.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		LOGGER.debug(" test param : {}", params.get("test"));

		LOGGER.debug(" isPop : {}", params.get("isPop"));
		LOGGER.debug(" param01 : {}", params.get("param01"));
		LOGGER.debug(" param02 : {}", params.get("param02"));

		// MessageSource 사용 예시.
		LOGGER.debug("fail.common.dbmsg : {}", messageAccessor.getMessage(SampleConstants.SAMPLE_DBMSG));

		// 호출될 화면
		return "sample/sampleView";
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/popupSample.do")
	public String popupSample(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "sample/popupSample";
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/main.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "sample/main";
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleReport.do")
	public String sampleReport(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "sample/sampleReport";
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleGridModify.do")
	public String sampleGridModify(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		LOGGER.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		LOGGER.debug(" test param : {}", params.get("test"));

		// 호출될 화면
		return "sample/sampleGridModify";
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleMultiGridList.do")
	public String sampleMultiGridList(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		LOGGER.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		LOGGER.debug(" test param : {}", params.get("test"));

		// 호출될 화면
		return "sample/sampleMultiGridList";
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleGridExcelUpload.do")
	public String sampleGridExcelUpload(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		LOGGER.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		LOGGER.debug(" test param : {}", params.get("test"));

		// 호출될 화면
		return "sample/sampleGridExcelUpload";
	}

	/**
	 * 화면 호출. - 데이터 포함 호출.
	 */
	@RequestMapping(value = "/sampleList.do")
	public String selectSample2View(@ModelAttribute("searchVO") SampleDefaultVO searchVO,
			@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		LOGGER.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		LOGGER.debug(" test param : {}", params.get("test"));

		// Map을 이용한 파라미터 사용 예시.
		// 기본으로 사용.
		List<EgovMap> sampleListByPrams = sampleService.selectSampleList(params);

		// VO 를 이용한 파라미터 사용 예시.
		// 기본적으로 @RequestParam Map<String, Object> params 를 사용하는 것으로 정함.
		List<EgovMap> sampleList = sampleService.selectSampleList(searchVO);

		if (params.isEmpty()) {
			params.put("test", "test");
		}

		// 화면 단으로 전달할 데이터.
		model.addAttribute("resultList", sampleListByPrams);

		// 호출될 화면
		return "sample/sampleList";
	}

	// ajax List 조회.
	@RequestMapping(value = "/selectJsonSampleList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectJsonSampleList(@ModelAttribute("searchVO") SampleDefaultVO searchVO,
			@RequestParam Map<String, Object> params, ModelMap model) {

		// 검색 파라미터 확인.
		LOGGER.debug("sId : {}", params.get("sId"));
		LOGGER.debug("sName : {}", params.get("sName"));

		// 조회.
		List<EgovMap> sampleList = sampleService.selectSampleList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(sampleList);
	}

	// grid data 전송 예제.
	@RequestMapping(value = "/saveSampleGridData", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSampleGridData(@RequestBody ArrayList<Object> params, Model model) {

		params.forEach(obj -> {
			LOGGER.debug("Product : {}", ((Map<String, Object>) obj).get("Product"));
			LOGGER.debug("Price : {}", ((Map<String, Object>) obj).get("Price"));
		});

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	/**
	 * Map을 이용한 Grid 편집 데이터 저장/수정/삭제 데이터 처리 샘플.
	 *
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSampleGridByMap.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSampleGrid(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); // 수정 리스트 얻기
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // 추가 리스트 얻기
		List<Object> removeList = params.get(AppConstants.AUIGRID_REMOVE); // 제거 리스트 얻기

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		if (updateList.size() > 0) {
			Map hm = null;
			Map<String, Object> updateMap = (Map<String, Object>) updateList.get(0);

			LOGGER.info("0 번째 id : {}", updateMap.get("id"));

			updateList.forEach(obj -> {
				LOGGER.debug("update id : {}", ((Map<String, Object>) obj).get("id"));
				LOGGER.debug("update name : {}", ((Map<String, Object>) obj).get("name"));
			});

			// for (Object map : updateList) {
			// hm = (HashMap<String, Object>) map;
			//
			// logger.info("id : {}", (String) hm.get("id"));
			// logger.info("name : {}", (String) hm.get("name"));
			// }
		}

		// 콘솔로 찍어보기
		LOGGER.info("수정 : {}", updateList.toString());
		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("삭제 : {}", removeList.toString());

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	/**
	 * VO 을 이용한 Grid 편집 데이터 저장/수정/삭제 데이터 처리 샘플.
	 *
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSampleGridByVO.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSampleGridByVO(@RequestBody GridDataSet<SampleGridForm> dataSet,
			Model model) {

		List<SampleGridForm> updateList = dataSet.getUpdate(); // 수정 리스트 얻기
		List<SampleGridForm> addList = dataSet.getAdd(); // 추가 리스트 얻기
		List<SampleGridForm> removeList = dataSet.getRemove(); // 제거 리스트 얻기

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		addList.forEach(form -> {
			LOGGER.debug("add id : {}", form.getId());
			LOGGER.debug(" add name : {}", form.getName());
			LOGGER.debug(" add date : {}", form.getDate());
		});

		for (SampleGridForm form : updateList) {
			LOGGER.info(" update id : {}", form.getId());
			LOGGER.info(" update name : {}", form.getName());
			LOGGER.info(" update date : {}", form.getDate());
		}

		// 콘솔로 찍어보기
		LOGGER.info("수정 : {}", updateList.toString());
		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("삭제 : {}", removeList.toString());

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	/*
	 * sampleUpload.jsp 호출.
	 */
	@RequestMapping(value = "/sampleUploadView.do")
	public String sampleUploadView(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug(" appName : {}", appName);
		return "sample/sampleUploadView";
	}

	@RequestMapping(value = "/sampleExcelUploadView.do")
	public String sampleExcelUploadView(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug(" appName : {}", appName);
		return "sample/sampleExcelUploadView";
	}

	/**
	 * Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sampleUpload.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovFormBasedFileVo>> sampleUpload(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"subPath1" + File.separator + "subPath2", AppConstants.UPLOAD_MAX_FILE_SIZE);

		String param01 = (String) params.get("param01");
		LOGGER.debug("param01 : {}", param01);
		LOGGER.debug("list.size : {}", list.size());
		// serivce 에서 파일정보를 가지고, DB 처리.
		// TODO : 에러 발생시 파일 삭제 처리 예정.
		return ResponseEntity.ok(list);
	}

	/**
	 * 공통 파일 테이블 사용 Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sampleUploadCommon.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovFormBasedFileVo>> sampleUploadCommon(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"subPath1" + File.separator + "subPath2", AppConstants.UPLOAD_MAX_FILE_SIZE);

		String param01 = (String) params.get("param01");
		LOGGER.debug("param01 : {}", param01);
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		return ResponseEntity.ok(list);
	}

	/**
	 * 저장 샘플.
	 *
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSample", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> saveSample(HttpServletRequest req, HttpServletResponse res,
			@RequestBody Map<String, Object> params, @RequestParam Map<String, Object> queryString, Model model) {

		// 꼭 필요한 경우만 사용.
		String queryStringParameter = (String) queryString.get("param01");
		LOGGER.debug("queryStringParameter : {}", queryStringParameter);

		// 꼭 필요한 경우만 사용.
		String queryStringReq = (String) req.getParameter("param01");
		LOGGER.debug("queryStringReq : {}", queryStringReq);

		// 기본 파라미터 사용.
		String id = (String) params.get("id");
		String name = (String) params.get("name");
		String description = (String) params.get("description");

		// 화면에서 같은 이름으로 파라미터를 넘기는 경우 처리.
		List<String> multis = (List<String>) params.get("multi");

		Integer seq = 0;

		LOGGER.debug("multi : {}", multis.size());

		for (String multi : multis) {
			LOGGER.debug("multi : {}", multi);
		}

		LOGGER.debug("id : {}", id);

		// message properties 설정 해야함.
		// eTRUST 에서는 DB에 의해 관리할 예정임.
		Precondition.checkNotNull(id, "id은 필수 항목입니다.");
		Precondition.checkNotNull(name, "name은 필수 항목입니다.");
		// Precondition.checkArgument(seq > 0, "seq은 필수 입력값입니다.");

		LOGGER.debug("id : {}", id);
		LOGGER.debug("name : {}", name);
		LOGGER.debug("description : {}", description);

		// serivce DB 처리.
		sampleService.insertSample(params);

		Map<String, Object> ret = new HashMap<>();
		ret.put("id", id);
		ret.put("name", name);
		ret.put("description", description);
		ret.put("seq", seq);

		List list = new ArrayList<Map<String, Object>>();
		list.add(ret);
		list.add(ret);
		list.add(ret);
		list.add(ret);

		Map<String, Object> retForList = new HashMap<>();

		retForList.put("param01", "param01");
		retForList.put("param02", "param02");
		retForList.put("data", list);

		return ResponseEntity.ok(retForList);
	}

	/*
	 * ================================================================================ 전자정부 예제 샘플
	 * ================================================================================
	 */

	/**
	 * 글 등록 화면을 조회한다.
	 * 
	 * @param searchVO
	 *            - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "egovSampleRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSample.do", method = RequestMethod.GET)
	public String addSampleView(@ModelAttribute("searchVO") SampleDefaultVO searchVO, Model model) {
		model.addAttribute("sampleVO", new SampleVO());
		return "sample/egovSampleRegister";
	}

	/**
	 * 글을 등록한다.
	 * 
	 * @param sampleVO
	 *            - 등록할 정보가 담긴 VO
	 * @param searchVO
	 *            - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSample.do", method = RequestMethod.POST)
	public String addSample(@ModelAttribute("searchVO") SampleDefaultVO searchVO, SampleVO sampleVO,
			BindingResult bindingResult, Model model, SessionStatus status) {

		if (bindingResult.hasErrors()) {
			model.addAttribute("sampleVO", sampleVO);
			return "sample/egovSampleRegister";
		}

		sampleService.insertSample(sampleVO);
		status.setComplete();
		return "forward:/egovSampleList.do";
	}

	/**
	 * 글 수정화면을 조회한다.
	 * 
	 * @param id
	 *            - 수정할 글 id
	 * @param searchVO
	 *            - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "egovSampleRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateSampleView.do")
	public String updateSampleView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") SampleDefaultVO searchVO, Model model) {
		SampleVO sampleVO = new SampleVO();
		sampleVO.setId(id);
		// 변수명은 CoC 에 따라 sampleVO
		model.addAttribute(selectSample(sampleVO, searchVO));
		return "sample/egovSampleRegister";
	}

	/**
	 * 글을 조회한다.
	 * 
	 * @param sampleVO
	 *            - 조회할 정보가 담긴 VO
	 * @param searchVO
	 *            - 목록 조회조건 정보가 담긴 VO
	 * @return @ModelAttribute("sampleVO") - 조회한 정보
	 * @exception Exception
	 */
	public SampleVO selectSample(SampleVO sampleVO, @ModelAttribute("searchVO") SampleDefaultVO searchVO) {
		return sampleService.selectSample(sampleVO);
	}

	/**
	 * 글을 수정한다.
	 * 
	 * @param sampleVO
	 *            - 수정할 정보가 담긴 VO
	 * @param searchVO
	 *            - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateSample.do")
	public String updateSample(@ModelAttribute("searchVO") SampleDefaultVO searchVO, SampleVO sampleVO,
			BindingResult bindingResult, Model model, SessionStatus status) {

		if (bindingResult.hasErrors()) {
			model.addAttribute("sampleVO", sampleVO);
			return "sample/egovSampleRegister";
		}

		sampleService.updateSample(sampleVO);
		status.setComplete();
		return "forward:/egovSampleList.do";
	}

	/**
	 * 글을 삭제한다.
	 * 
	 * @param sampleVO
	 *            - 삭제할 정보가 담긴 VO
	 * @param searchVO
	 *            - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/egovSampleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteSample.do")
	public String deleteSample(SampleVO sampleVO, @ModelAttribute("searchVO") SampleDefaultVO searchVO,
			SessionStatus status) {
		sampleService.deleteSample(sampleVO);
		status.setComplete();
		return "forward:/egovSampleList.do";
	}

	@RequestMapping(value = "/invalidToken.do")
	public String invalidToken(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		return "error/nomenu/callcenterError";
	}
}
