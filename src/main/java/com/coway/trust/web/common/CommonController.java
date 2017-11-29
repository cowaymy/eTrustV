package com.coway.trust.web.common;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.config.DatabaseDrivenMessageSource;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovResourceCloseHelper;
import com.coway.trust.util.EgovWebUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class CommonController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private DatabaseDrivenMessageSource dbMessageSource;

	@RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		LOGGER.debug("groupCode : {}", params);

		List<EgovMap> codeList = commonService.selectCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/main.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "common/main";
	}

	@RequestMapping(value = "/unauthorized.do")
	public String unauthorized(@RequestParam Map<String, Object> params, ModelMap model) {
		return "/error/unauthorized";
	}

	@RequestMapping(value = "/exportGrid.do")
	public void export(HttpServletRequest request, HttpServletResponse response) throws IOException, URISyntaxException {
		// AUIGrid 가 xlsx, csv, xml 등의 형식을 작성하여 base64 로 인코딩하여 data 파라메터로 post 요청을 합니다.
		// 해당 서버에서는 base64 로 인코딩 된 데이터를 디코드하여 다운로드 가능하도록 붙임으로 마무리합니다.
		// 참고로 org.apache.commons.codec.binary.Base64 클래스 사용을 위해는 commons-codec-1.4.jar 파일이 필요합니다.

		String pData = "data";
		String pExtension = "extension";
		String pFileName = "filename";
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

		String data = request.getParameter(pData); // 파라메터 data
		String extension = request.getParameter(pExtension); // 파라메터 확장자
		String reqFileName = request.getParameter(pFileName); // 파라메터 파일명

		if (data == null) {
			String body = EgovWebUtil.getBody(request);
			List<NameValuePair> bodyParams = URLEncodedUtils.parse(new URI("tempUrl?" + body),
					AppConstants.DEFAULT_CHARSET);

			for (NameValuePair nameValuePair : bodyParams) {
				if (pData.equals(nameValuePair.getName())) {
					data = nameValuePair.getValue();
				}

				if (pExtension.equals(nameValuePair.getName())) {
					extension = nameValuePair.getValue();
				}
			}
		}

		byte[] dataByte = Base64.decodeBase64(data.getBytes()); // 데이터 base64 디코딩

		// csv 를 엑셀에서 열기 위해서는 euc-kr 로 작성해야 함.
		try {
			if (extension.equals("csv")) {
				String sting = new String(dataByte, AppConstants.DEFAULT_CHARSET);
				outputStream.write(sting.getBytes("euc-kr"));
			} else {
				outputStream.write(dataByte);
			}
		} catch (UnsupportedEncodingException e) {
			throw new ApplicationException(e);
		} catch (IOException e) {
			throw new ApplicationException(e);
		} finally {
			EgovResourceCloseHelper.close(outputStream);
		}

		String fileName = "export." + extension; // 다운로드 될 파일명

		if (CommonUtils.isNotEmpty(reqFileName)) {
			fileName = reqFileName + "." + extension;
		}

		response.reset();
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setHeader("Content-Length", String.valueOf(outputStream.size()));

		ServletOutputStream sos = null;
		try {
			sos = response.getOutputStream();
			sos.write(outputStream.toByteArray());
			sos.flush();
			sos.close();
		} catch (IOException e) {
			throw new ApplicationException(e);
		} finally {
			EgovResourceCloseHelper.close(sos);
		}
	}

	@RequestMapping(value = "/db-messages/reload.do")
	public void reload(@RequestParam Map<String, Object> params) {
		dbMessageSource.reload();
	}

	@RequestMapping(value = "/selectBranchCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = commonService.selectBranchList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectReasonCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReasonCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = commonService.selectReasonCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	/**
	 * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
	 * 
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/getAccountList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getAccountList(@RequestParam Map<String, Object> params) {
		List<EgovMap> resultList = commonService.getAccountList(params);
		return ResponseEntity.ok(resultList);
	}

	/**
	 * IssuedBank 정보 조회
	 * 
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/getIssuedBankList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getIssuedBankList(@RequestParam Map<String, Object> params) {
		List<EgovMap> resultList = commonService.selectBankList(params);
		return ResponseEntity.ok(resultList);
	}

	/**
	 * Branch ID로 User 정보 조회
	 * 
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/getUsersByBranch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getUsersByBranch(@RequestParam Map<String, Object> params) {
		List<EgovMap> resultList = commonService.getUsersByBranch(params);
		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectAddrSelCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAddrSelCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = commonService.selectAddrSelCode(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectProductCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = commonService.selectProductCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectInStckSelCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInStckSelCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = commonService.selectInStckSelCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/searchPopList.do")
	public String searchPopList(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("url", params);
		// 호출될 화면
		return "/common/searchPop";
	}

	@RequestMapping(value = "/selectStockLocationList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStockLocationList(@RequestParam Map<String, Object> params,
			ModelMap model) {

		LOGGER.info("selectStockLocationList: {}", params);

		List<EgovMap> codeList = commonService.selectStockLocationList(params);
		LOGGER.info("selectStockLocationList: {}", codeList.toString());
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectStockLocationList2.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStockLocationList2(@RequestParam Map<String, Object> params,
			ModelMap model) {

		LOGGER.info("selectStockLocationList: {}", params);

		String searchgb = (String) params.get("searchlocgb");
		String[] searchgbvalue = searchgb.split("∈");
		LOGGER.debug(" :::: {}", searchgbvalue.length);

		params.put("searchlocgb", searchgbvalue);

		List<EgovMap> codeList = commonService.selectStockLocationList(params);
		LOGGER.info("selectStockLocationList: {}", codeList.toString());
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/customerPop.do")
	public String customerPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("callPrgm", params.get("callPrgm"));

		return "common/customerPop";
	}

	@RequestMapping(value = "/memberPop.do")
	public String memberPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("callPrgm", params.get("callPrgm"));

		return "common/memberPop";
	}

	@RequestMapping(value = "/selectBrnchIdByPostCode.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectBrnchIdByPostCode(@RequestParam Map<String, Object> params) {
		EgovMap result = commonService.selectBrnchIdByPostCode(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectProductList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAppTypeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = commonService.selectProductList();
		return ResponseEntity.ok(codeList);
	}

	/**
	 * Payment - Adjustment CN/DN : Adjustment Reason 정보 조회
	 * 
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectAdjReasontList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAdjReasonList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = commonService.selectAdjReasonList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/SysdateCall.do", method = RequestMethod.GET)
	public ResponseEntity<Map> SysdateCall(@RequestParam Map<String, Object> params) {
		String rvalue = commonService.SysdateCall(params);
		Map<String, Object> rmap = new HashMap();
		rmap.put("date", rvalue);
		return ResponseEntity.ok(rmap);
	}

	@RequestMapping(value = "/getPublicHolidayList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getPublicHolidayList(@RequestParam Map<String, Object> params) {
		List<EgovMap> holidayList = commonService.getPublicHolidayList(params);
		return ResponseEntity.ok(holidayList);
	}
}
