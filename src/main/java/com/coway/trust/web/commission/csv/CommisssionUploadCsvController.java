package com.coway.trust.web.commission.csv;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.commission.calculation.CommissionCalculationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@RestController
@RequestMapping("/commission/csv")
public class CommisssionUploadCsvController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommisssionUploadCsvController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Resource(name = "commissionCalculationService")
	private CommissionCalculationService commissionCalculationService;


	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity<String> readExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {
		//ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<IncentiveDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, IncentiveDataVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		//marster
		Map mMap = new HashMap();
		mMap.put("uploadID",request.getParameter("type"));
		mMap.put("statusID","1");
		if((CommissionConstants.COMIS_INCENTIVE).equals(request.getParameter("type"))){
			String dt = CommonUtils.getCalMonth(-1);
			mMap.put("actionDate",dt.substring(0,6));
		}else{
			mMap.put("actionDate","");
		}
		mMap.put("creator",loginId);
		mMap.put("updator",loginId);
		mMap.put("memberTypeID",request.getParameter("memberType"));

		commissionCalculationService.insertIncentiveMaster(mMap);
		String uploadId = commissionCalculationService.selectUploadId(mMap);

		for (IncentiveDataVO vo : vos) {
			/*det.Updated = DateTime.Now;*/
			Map map = new HashMap();
			map.put("uploadID",uploadId);
			map.put("statusID","1");
			map.put("validStatusID","1");
			map.put("userMemberCode",vo.getMemberCode());
			map.put("userRefCode",vo.getRefCode());
			map.put("userTargetAmt",vo.getTargetAmt());
			map.put("userRefLvl",vo.getLevel());
			map.put("sysMemberID","0");
			map.put("sysTargetAmt","0");
			map.put("sysRefLvl","0");
			map.put("updated",loginId);
			map.put("sysMemberTypeID","0");

			commissionCalculationService.insertIncentiveDetail(map);
		}
		commissionCalculationService.callIncentiveDetail(Integer.parseInt(uploadId));

		return ResponseEntity.ok(uploadId);
	}

	@RequestMapping(value = "/mboUpload", method = RequestMethod.POST)
	public ResponseEntity<Integer> readMboExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<IncentiveDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, IncentiveDataVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		//master
		Map<String, Object> mMap = new HashMap<String, Object>();
		mMap.put("uploadTypeID",request.getParameter("type"));
		mMap.put("statusID","1");

		String dt = CommonUtils.getCalMonth(0);
		mMap.put("actionDate",dt.substring(0,6));

		mMap.put("creator",loginId);
		mMap.put("updator",loginId);
		mMap.put("memberTypeID",request.getParameter("memberType"));

		int uploadId = commissionCalculationService.mboMasterUploadId();
		mMap.put("uploadId",uploadId);

		commissionCalculationService.insertMboMaster(mMap);


		for (IncentiveDataVO vo : vos) {
			/*det.Updated = DateTime.Now;*/
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("uploadID",uploadId);
			map.put("statusID","1");
			map.put("validStatusID","1");
			map.put("userMemberCode",vo.getMemberCode());
			map.put("userRefCode",vo.getRefCode());
			map.put("userTargetAmt",vo.getTargetAmt());
			map.put("userRefLvl",vo.getLevel());
			map.put("sysMemberID","0");
			map.put("sysTargetAmt","0");
			map.put("sysRefLvl","0");
			map.put("updated",loginId);
			map.put("sysMemberTypeID","0");

			commissionCalculationService.insertMboDetail(map);
		}
		commissionCalculationService.callMboDetail(uploadId);

		return ResponseEntity.ok(uploadId);
	}

	@RequestMapping(value = "/cffUpload", method = RequestMethod.POST)
	public ResponseEntity<Integer> readCffExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<CFFDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CFFDataVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		//master
		Map<String, Object> mMap = new HashMap<String, Object>();
		mMap.put("uploadTypeID",request.getParameter("type"));
		mMap.put("statusID","1");

		String dt = CommonUtils.getCalMonth(-1);
		mMap.put("actionDate",dt.substring(0,6));

		mMap.put("creator",loginId);
		mMap.put("updator",loginId);
		mMap.put("memberTypeID",request.getParameter("memberType"));

		int uploadId = commissionCalculationService.cffMasterUploadId();
		mMap.put("uploadId",uploadId);

		commissionCalculationService.insertCffMaster(mMap);

		for (CFFDataVO vo : vos) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("uploadID",uploadId);
			map.put("statusID","1");
			map.put("validStatusID","1");
			map.put("userMemberCode",vo.getMemberCode());
			map.put("userCffMark",vo.getMark());
			map.put("sysMemberID","0");
			map.put("sysTargetAmt","0");
			map.put("sysRefLvl","0");
			map.put("updated",loginId);
			map.put("sysMemberTypeID","0");

			commissionCalculationService.insertCffDetail(map);
		}
		commissionCalculationService.callCffDetail(uploadId);

		return ResponseEntity.ok(uploadId);
	}

	@RequestMapping(value = "/uploadNonIncnt", method = RequestMethod.POST)
	public ResponseEntity<String> readNonIncntExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {
		//ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<NonIncentiveDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, NonIncentiveDataVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		//marster
		Map mMap = new HashMap();
		mMap.put("uploadID",request.getParameter("type"));
		mMap.put("statusID","1");
		if((CommissionConstants.COMIS_NONMON_INCENTIVE).equals(request.getParameter("type"))){
			String dt = CommonUtils.getCalMonth(-1);
			mMap.put("actionDate",dt.substring(0,6));
		}
		mMap.put("creator",loginId);
		mMap.put("updator",loginId);
		mMap.put("memberTypeID",request.getParameter("memberType"));

		commissionCalculationService.insertNonIncentiveMaster(mMap);
		String uploadId = commissionCalculationService.selectNonIncentiveUploadId(mMap);

		for (NonIncentiveDataVO vo : vos) {
			/*det.Updated = DateTime.Now;*/
			Map map = new HashMap();
			map.put("uploadID",uploadId);
			map.put("statusID","1");
			map.put("validStatusID","1");
			map.put("userMemberCode",vo.getMemberCode());
			map.put("userRefCode",vo.getRefCode());
			map.put("userTargetAmt",vo.getTargetAmt());
			map.put("userRefLvl",vo.getLevel());
			map.put("sysMemberID","0");
			map.put("sysTargetAmt","0");
			map.put("sysRefLvl","0");
			map.put("updated",loginId);
			map.put("sysMemberTypeID","0");

			commissionCalculationService.insertNonIncentiveDetail(map);
		}
		commissionCalculationService.callNonIncentiveDetail(Integer.parseInt(uploadId));

		return ResponseEntity.ok(uploadId);
	}

	@RequestMapping(value = "/bonusCandyUpload", method = RequestMethod.POST)
	public ResponseEntity<String> readBonusCandyExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {
		//ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<BonusCandyDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, BonusCandyDataVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		//marster
		Map mMap = new HashMap();
		mMap.put("uploadID",request.getParameter("type"));
		mMap.put("statusID","1");
		mMap.put("creator",loginId);
		mMap.put("updator",loginId);
		mMap.put("memberTypeID",request.getParameter("memberType"));

		String dt = CommonUtils.getCalMonth(-1);
		mMap.put("actionDate",dt.substring(0,6));

		commissionCalculationService.insertIncentiveMaster(mMap);
		String uploadId = commissionCalculationService.selectUploadId(mMap);

		for (BonusCandyDataVO vo : vos) {
			/*det.Updated = DateTime.Now;*/
			Map map = new HashMap();
			map.put("uploadID",uploadId);
			map.put("statusID","1");
			map.put("validStatusID","1");
			map.put("userMemberCode",vo.getMemberCode());
			map.put("userRefCode",vo.getRefCode());
			map.put("userTargetAmt","0");
			map.put("userRefLvl",vo.getLevel());
			map.put("sysMemberID","0");
			map.put("sysTargetAmt","0");
			map.put("sysRefLvl","0");
			map.put("updated",loginId);
			map.put("sysMemberTypeID","0");
			map.put("bonusCandyRate", vo.getBonusCandyRate());

			commissionCalculationService.insertIncentiveDetail(map);
		}
		commissionCalculationService.callIncentiveDetail(Integer.parseInt(uploadId));

		return ResponseEntity.ok(uploadId);
	}

	@RequestMapping(value = "/uploadAdvIncnt", method = RequestMethod.POST)
	public ResponseEntity<String> readAdvIncntExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {
		//ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<AdvIncentiveDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, AdvIncentiveDataVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		//master
		Map mMap = new HashMap();
//		Map<String, Object> params = new HashMap<String, Object>();
//		params.put("code",request.getParameter("type"));
//		List<EgovMap> sampleList = commissionCalculationService.advIncentiveSample(params);

		mMap.put("uploadID",request.getParameter("type"));
		mMap.put("statusID","1");
//		if(("adv").equals(request.getParameter("type"))){
			String requestMonth = String.format("%02d", Integer.valueOf(vos.get(0).getMonth()));
			String rqstDt = //(String.valueOf(requestDay)
					(vos.get(0).getYear() + String.valueOf(requestMonth) );

			//String dt = CommonUtils.getCalMonth(-1);
			mMap.put("actionDate",rqstDt);
//		}
		mMap.put("creator",loginId);
		mMap.put("updator",loginId);
		mMap.put("memberTypeID",request.getParameter("memberType"));

		commissionCalculationService.insertAdvIncentiveMaster(mMap);
		String uploadId = commissionCalculationService.selectAdvIncentiveUploadId(mMap);

		for (AdvIncentiveDataVO vo : vos) {
			/*det.Updated = DateTime.Now;*/
			Map map = new HashMap();
			map.put("uploadID",uploadId);
			map.put("statusID","1");
			map.put("validStatusID","1");
			map.put("userMemberCode",vo.getMemberCode());
			map.put("userRefCode",vo.getRefCode());
			map.put("userTargetAmt",vo.getTargetAmt());
			map.put("userRefLvl",vo.getLevel());
			map.put("sysMemberID","0");
			map.put("sysTargetAmt","0");
			map.put("sysRefLvl","0");
			map.put("updated",loginId);
			map.put("sysMemberTypeID","0");
			map.put("advDt",vo.getAdvDt());

			commissionCalculationService.insertAdvIncentiveDetail(map);
		}
		commissionCalculationService.callAdvIncentiveDetail(Integer.parseInt(uploadId));

		return ResponseEntity.ok(uploadId);
	}

}
