package com.coway.trust.web.sample;

import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.SampleApplication;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.AuthVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sample")
public class SampleController {

	private static final Logger logger = LoggerFactory.getLogger(SampleController.class);

	@Resource(name = "sampleService")
	private SampleService sampleService;

	// 멀티 서비스 이용시 업무 + Application 에서 공통으로 사용되는 서비스를 구현한다.
	@Autowired
	private SampleApplication sampleApplication;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

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
	 * 화면 호출.
	 * - publish 적용.
	 * - 버튼 퀀한 적용.
	 */
	@RequestMapping(value = "/publishSample.do")
	public String publishSample(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 화면별 버튼 권한 리스트 예제.
		Map<String, Object> buttonMap = new HashMap<>();
		
		buttonMap.put("save", true);
		buttonMap.put("update", true);
		buttonMap.put("delete", true);
		
		model.addAttribute("auth", buttonMap);
		
		// 호출될 화면
		return "sample/publishSample";
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
	public ResponseEntity<List<EgovMap>> selectClobData(@RequestParam Map<String, Object> params, Model model, Date toDate )
			throws Exception {
		List<EgovMap> list = sampleService.selectClobData(params);
		// List<EgovMap> list2 = sampleService.selectClobOtherData(params);
		return ResponseEntity.ok(list);
	}

	/**
	 * responseBody에 json data로 응답을 보내는 경우.
	 * 
	 * 1) return type void 인 경우 : response body 로 보내려면, @ResponseBody 를 기술해 줌.
	 * 2) return type을 ResponseEntity<ReturnMessage> 로 하여 보내 준다. ( @ResponseBody 필요 없음 )
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
		
//		return ResponseEntity.ok(new ReturnMessage());
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleView.do")
	public String sampleView(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		logger.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		logger.debug(" test param : {}", params.get("test"));
		
		logger.debug(" isPop : {}", params.get("isPop"));
		logger.debug(" param01 : {}", params.get("param01"));
		logger.debug(" param02 : {}", params.get("param02"));

		// MessageSource 사용 예시.
		logger.debug("fail.common.dbmsg : {}", messageAccessor.getMessage(SampleConstants.SAMPLE_DBMSG));
		
		// 화면에서 보여줄 데이터.
		AuthVO auth = new AuthVO();
		auth.setInsert(true);
		auth.setRead(true);
		auth.setUpdate(true);
		auth.setDelete(false);
		
		model.addAttribute("auth", auth);

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
	@RequestMapping(value = "/sampleGridModify.do")
	public String sampleGridModify(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		logger.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		logger.debug(" test param : {}", params.get("test"));

		// 호출될 화면
		return "sample/sampleGridModify";
	}
	
	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleMultiGridList.do")
	public String sampleMultiGridList(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		logger.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		logger.debug(" test param : {}", params.get("test"));

		// 호출될 화면
		return "sample/sampleMultiGridList";
	}

	/**
	 * 화면 호출.
	 */
	@RequestMapping(value = "/sampleGridExcelUpload.do")
	public String sampleGridExcelUpload(@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		logger.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		logger.debug(" test param : {}", params.get("test"));

		// 호출될 화면
		return "sample/sampleGridExcelUpload";
	}

	/**
	 * 화면 호출. - 데이터 포함 호출.
	 */
	@RequestMapping(value = "/selectSampleList.do")
	public String selectSample2View(@ModelAttribute("searchVO") SampleDefaultVO searchVO,
			@RequestParam Map<String, Object> params, ModelMap model) {

		// 프로퍼티 사용 예시.
		logger.debug(" appName : {}", appName);
		// 파라미터 사용 예시.
		logger.debug(" test param : {}", params.get("test"));

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
		logger.debug("sId : {}", params.get("sId"));
		logger.debug("sName : {}", params.get("sName"));

		// 조회.
		List<EgovMap> sampleList = sampleService.selectSampleList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(sampleList);
	}

	// grid data 전송 예제.
	@RequestMapping(value = "/saveSampleGridData", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSampleGridData(@RequestBody ArrayList<Object> params, Model model) {

		params.forEach(obj -> {
			logger.debug("Product : {}", ((Map<String, Object>) obj).get("Product"));
			logger.debug("Price : {}", ((Map<String, Object>) obj).get("Price"));
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
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSampleGridByMap.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSampleGrid(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> updateList = params.get(AppConstants.AUIGrid_UPDATE); // 수정 리스트 얻기
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // 추가 리스트 얻기
		List<Object> removeList = params.get(AppConstants.AUIGRID_REMOVE); // 제거 리스트 얻기

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		if (updateList.size() > 0) {
			Map hm = null;
			Map<String, Object> updateMap = (Map<String, Object>) updateList.get(0);

			logger.info("0 번째 id : {}", updateMap.get("id"));

			updateList.forEach(obj -> {
				logger.debug("update id : {}", ((Map<String, Object>) obj).get("id"));
				logger.debug("update name : {}", ((Map<String, Object>) obj).get("name"));
			});

			// for (Object map : updateList) {
			// hm = (HashMap<String, Object>) map;
			//
			// logger.info("id : {}", (String) hm.get("id"));
			// logger.info("name : {}", (String) hm.get("name"));
			// }
		}

		// 콘솔로 찍어보기
		logger.info("수정 : {}", updateList.toString());
		logger.info("추가 : {}", addList.toString());
		logger.info("삭제 : {}", removeList.toString());

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	/**
	 * VO 을 이용한 Grid 편집 데이터 저장/수정/삭제 데이터 처리 샘플.
	 *
	 * @param request
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
			logger.debug("add id : {}", form.getId());
			logger.debug(" add name : {}", form.getName());
			logger.debug(" add date : {}", form.getDate());
		});

		for (SampleGridForm form : updateList) {
			logger.info(" update id : {}", form.getId());
			logger.info(" update name : {}", form.getName());
			logger.info(" update date : {}", form.getDate());
		}

		// 콘솔로 찍어보기
		logger.info("수정 : {}", updateList.toString());
		logger.info("추가 : {}", addList.toString());
		logger.info("삭제 : {}", removeList.toString());

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
		logger.debug(" appName : {}", appName);
		return "sample/sampleUpload";
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
				AppConstants.UPLOAD_MAX_FILE_SIZE);

		String param01 = (String) params.get("param01");
		logger.debug("param01 : {}", param01);
		logger.debug("list.size : {}", list.size());
		// serivce 에서 파일정보를 가지고, DB 처리.
		// TODO : 에러 발생시 파일 삭제 처리 예정.
		return ResponseEntity.ok(list);
	}

	/**
	 * 저장 샘플.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSample", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> saveSample(HttpServletRequest req, HttpServletResponse res,
			@RequestBody Map<String, Object> params, @RequestParam Map<String, Object> queryString, Model model) {

		// 꼭 필요한 경우만 사용.
		String queryStringParameter = (String) queryString.get("param01");
		logger.debug("queryStringParameter : {}", queryStringParameter);

		// 꼭 필요한 경우만 사용.
		String queryStringReq = (String) req.getParameter("param01");
		logger.debug("queryStringReq : {}", queryStringReq);

		// 기본 파라미터 사용.
		String id = (String) params.get("id");
		String name = (String) params.get("name");
		String description = (String) params.get("description");

		// 화면에서 같은 이름으로 파라미터를 넘기는 경우 처리.
		List<String> multis = (List<String>) params.get("multi");

		Integer seq = 0;

		logger.debug("multi : {}", multis.size());

		for (String multi : multis) {
			logger.debug("multi : {}", multi);
		}

		logger.debug("id : {}", id);

		// message properties 설정 해야함.
		// eTRUST 에서는 DB에 의해 관리할 예정임.
		Precondition.checkNotNull(id, "id은 필수 항목입니다.");
		Precondition.checkNotNull(name, "name은 필수 항목입니다.");
		// Precondition.checkArgument(seq > 0, "seq은 필수 입력값입니다.");

		logger.debug("id : {}", id);
		logger.debug("name : {}", name);
		logger.debug("description : {}", description);

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
	 * @param status
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

}
