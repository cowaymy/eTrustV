package com.coway.trust.web.payment.autodebit.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.autodebit.service.ClaimService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovResourceCloseHelper;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class ClaimController {
	
	
	
	

	private static final Logger logger = LoggerFactory.getLogger(ClaimController.class);

	@Resource(name = "claimService")
	private ClaimService claimService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/******************************************************
	 * Claim List  
	 *****************************************************/	
	/**
	 * ClaimList 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initClaimList.do")
	public String initSearchPayment(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/claimList";
	}
	
	/**
	 * Claim List List(Master Grid) 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectClaimList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectClaimList(@ModelAttribute("searchVO") SampleDefaultVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
		// 조회.
        List<EgovMap> resultList = claimService.selectClaimList(params);
        
        // 조회 결과 리턴.        
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Claim Result Deactivate 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updateDeactivate.do", method = RequestMethod.POST)
    public ResponseEntity<List<EgovMap>> updateDeactivate(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model) {
    	
		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		// 처리.
		Map<String, Object> map = (Map<String, Object>)formList.get(0);
		claimService.updateDeactivate(map);
		
		// 조회.		
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("batchId", map.get("ctrlId"));
		
        List<EgovMap> resultList = claimService.selectClaimList(searchMap);
        
        // 조회 결과 리턴.        
        return ResponseEntity.ok(resultList);
		
    }
	
	
	/**
	 * Generate New Claim 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/generateNewClaim.do", method = RequestMethod.POST)
    public ResponseEntity<Map<String, Object>> generateNewClaim(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model) {
		
		
		Map<String, Object> returnMap = new HashMap<>();
		
		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
	
    	
    	//CRC Statement 정보 Map
    	Map<String, Object> claim = new HashMap<String, Object>();
    	
    	//CRC Statement 정보 Map에 데이터 세팅
    	if (formList.size() > 0) {
    		
    		formList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                claim.put((String)map.get("name"),map.get("value"));
                
                logger.debug("name : {}", map.get("name"));
                logger.debug("value : {}", map.get("value"));
    		});    		
    	}
		//검색 파라미터 확인.(화면 Form객체 입력값)
        logger.debug("new_claimType : {}", claim.get("new_claimType"));
        logger.debug("new_claimDay : {}", claim.get("new_claimDay"));
        logger.debug("new_issueBank : {}", claim.get("new_issueBank"));
        logger.debug("new_debitDate : {}", claim.get("new_debitDate"));        
        
		
		// HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다. 
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("issueBank", claim.get("new_issueBank"));
		searchMap.put("claimType", claim.get("new_claimType"));
		searchMap.put("status", "1");
		
        List<EgovMap> isActiveBatchList = claimService.selectClaimList(searchMap);
        
        if(isActiveBatchList.size() > 0){
        	returnMap.put("resultCode", "IS_BATCH");
        	returnMap.put("dataList", isActiveBatchList.get(0));
        }else{
        	//claimService.generateNewClaim(searchMap);
        	returnMap.put("resultCode", "IS_BATCH");
        	returnMap.put("dataList", new ArrayList<EgovMap>());
        	
        	
        }
        
        // 조회 결과 리턴.        
        return ResponseEntity.ok(returnMap);
		
    }
	
	
	/**
	 * Claim Create File 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/createClaimFile.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> createClaimFile(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model) throws Exception { 
	
		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		// Calim Master 데이터 조회
		Map<String, Object> map = (Map<String, Object>)formList.get(0);
		EgovMap claimMap = claimService.selectClaimById(map);
		
		// Claim Detail List 조회
		List<EgovMap> claimDetailList = claimService.selectClaimDetailById(claimMap);
		
		// 파일 생성하기
		if("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			//ALB
			if("2".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFileALB(claimMap, claimDetailList);
				this.createClaimFileNewALB(claimMap, claimDetailList);				
			}
			
			//CIMB
			if("3".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFileCIMB(claimMap, claimDetailList);
			}
			
			//HLBB
			if("5".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFileHLBB(claimMap, claimDetailList);
			}
			
			//MBB
			if("21".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFileMBB(claimMap, claimDetailList);
			}
			
			//PBB
			if("6".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFilePBB(claimMap, claimDetailList);
			}
			
			//RHB
			if("7".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFileRHB(claimMap, claimDetailList);				
			}
			
			//BSN
			if("9".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFileBSN(claimMap, claimDetailList);
			}
			
			//My Clear
			if("46".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				this.createClaimFileMyClear(claimMap, claimDetailList);
			}
		}else if("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))){
			this.createClaimFileCrcCIMB(claimMap, claimDetailList);
			
		}else if("134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))){
			this.createClaimFileFPX(claimMap, claimDetailList);			
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
		
    }
	
	
	/**********************************************
	 *
	 * 파일 생성하기 
	 * 
	 ***********************************************/
	/**
	 * ALB - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileALB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String sFile = "ALB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "yyyyMMdd") + "B01.txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/ALB/ClaimBankALB/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		
		/***********************************************
		 *  파일 내용 쓰기
		 ***********************************************/
		//헤더 작성		 
		String sText = "H|AUTODEBIT|";
		
		out.write(sText);
		out.newLine();
		out.flush();
		
		//본문 작성
		double iTotalAmt = 0;
		String stextDetails = "";
		String sDrAccNo = "";
		String sLimit = "";
		String sDocno = "";
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				//암호화는 나중에 하자
				//sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).ToString().Trim().PadLeft(15, ' ');
				sDrAccNo = StringUtils.leftPad("34204542899", 15, " ");
				
				sLimit = CommonUtils.getNumberFormat( String.valueOf(map.get("bankDtlAmt")), "0.00");
				String sBillDate = map.get("bankDtlDrDt") != null ? (String)map.get("bankDtlDrDt") : "1900-01-01";
				sDocno = (String)map.get("cntrctNOrdNo");
				stextDetails = "D|101|" + sDrAccNo + "|" + sLimit + "|" + CommonUtils.changeFormat(sBillDate, "yyyy-MM-dd" , "ddMMyyyy") + "| |" + sDocno + "|";
				iTotalAmt = iTotalAmt + Double.parseDouble(sLimit);
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
			}
		}
		
		//footer 작성
		String sTextBtn = "";
		sTextBtn = "T|" + claimDetailList.size() + "|" + CommonUtils.getNumberFormat( iTotalAmt, "0.00") +"|";
		
		out.write(sTextBtn);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		//String emailTitle = "CIMB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	/**
	 * ALB NEW - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileNewALB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
		String sFile = "AD_Billing_" + todayDate + ".txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/ALB/ClaimBankALB/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String hRecordType = "H";
		String hCreditAccNo = "140550010078613";
		String hCompanyName = "Coway (M) Sdn Bhd";
		String hFileBatchRefNo = String.valueOf(claimMap.get("ctrlId"));
		String hCollectionDate = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyyyy");
		String hSellerID = "AD10000101";
		String hCreditType = "S";
		
		String headerStr = hRecordType + "|" + hCreditAccNo + "|" + hCompanyName + "|" + hFileBatchRefNo + "|" + 
									hCollectionDate + "|" + hSellerID + "|" + hCreditType + "|";      
        		 
		out.write(headerStr);
		out.newLine();
		out.flush();
		
		//본문 작성
		long hashTotal = 0;
		long totalCollection = 0;
		
		String dRecordType = "D";
		String dDebtiAccNo = "";
		String dDebitAccName = "";
		String dBankCode = "MFBBMYKL";
		String dCollAmt = "";
		String dOrderNo = "";
		String dSellerInternalRefNo = "";
		String dBuyerNewICNo = "";
		String dBuyerOldICNo = "";
		String dBuyerBusinessRegNo = "";
		String dBuyerOtherIDValue = "";
		String dNotiReq = "N";
		String mobNo = "";
		String email1 = "";
		String email2 = "";
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				//암호화는 나중에 하자
				//string AccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).ToString().Trim();
				String accNo = "34204542899".trim();
				
				String accNRIC = ((String)map.get("bankDtlDrNric")).trim();
				dDebtiAccNo = accNo.length() > 17 ? accNo.substring(0, 17) : accNo;
				dDebitAccName = ((String)map.get("bankDtlDrName")).length() > 40 ? ((String)map.get("bankDtlDrName")).substring(0, 40) : (String)map.get("bankDtlDrName");
				dCollAmt = CommonUtils.getNumberFormat( String.valueOf(map.get("bankDtlAmt")), "0.00");
				dOrderNo = (String)map.get("cntrctNOrdNo");
				dSellerInternalRefNo =
						String.valueOf(map.get("bankDtlId")).length() > 40 ?
								(String.valueOf(map.get("bankDtlId"))).substring(0, 40) :
									String.valueOf(map.get("bankDtlId"));                 

				if (accNRIC.length() == 12) {
					dBuyerNewICNo = accNRIC;
				}else if (accNRIC.length() == 8) {
					dBuyerOldICNo = accNRIC;					
				}else {
					dBuyerBusinessRegNo = accNRIC;
				}
				
				String detailStr = dRecordType + "|" + dDebtiAccNo + "|" + dDebitAccName + "|" + dBankCode + "|" +
							dCollAmt + "|" + dOrderNo + "|" + dSellerInternalRefNo + "|" + dBuyerNewICNo + "|" +
							dBuyerOldICNo + "|" + dBuyerBusinessRegNo + "|" + dBuyerOtherIDValue + "|" + dNotiReq + "|" +
							mobNo + "|" + email1 + "|" + email2  + "|";
                 
				out.write(detailStr);
				out.newLine();
				out.flush();
				
				totalCollection +=  ((java.math.BigDecimal)map.get("bankDtlAmt")).longValue();
				hashTotal += Long.parseLong(CommonUtils.right(dDebtiAccNo,10));
			}
		}
		
		//footer 작성
		String tRecordType = "T";
		String tTotalRecord = String.valueOf(claimDetailList.size());
		String tTotalCollectionAmt = CommonUtils.getNumberFormat( totalCollection, "0.00");
		String tmpHashTotal = 	 (CommonUtils.getNumberFormat( hashTotal, "0000000000"));
		String tHashTotal = CommonUtils.right(tmpHashTotal,10);
		
		String trailerStr = "";
		trailerStr = tRecordType + "|" + tTotalRecord + "|" + tTotalCollectionAmt + "|"  + tHashTotal + "|";
		
		out.write(trailerStr);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		//String emailTitle = "CIMB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	
	}
	 
	
	/**
	 * CIMB - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileCIMB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String sFile = "CIMB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "yyyyMMdd") + "B01.dat";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/CIMB/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String sbatchNo = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy") + "01";
		String sSecCode = StringUtils.leftPad(String.valueOf((Integer.parseInt(sbatchNo) + 1208083646)), 10, " ");
		
		String sText = "01" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy") + "01" + "2120" + StringUtils.rightPad("WOONGJIN COWAY", 40, " ") +
        		 CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy") + sSecCode + StringUtils.rightPad("", 128, " ");
		
		out.write(sText);
		out.newLine();
		out.flush();
		
		//본문 작성
		String stextDetails = "";
		String sDocno = "";
		String sNRIC = "";
		String sDrName = "";
		String sDrAccNo = "";
		String sItemID = "";
		String sReservedA = "";
		String sReservedB = "";
		String sUnusedA = "";
		String sUnusedB = "";
		
		long sLimit = 0;
		long iTotalAmt = 0;
		long ihashtot3 = 0;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				sDocno = StringUtils.rightPad(String.valueOf(map.get("cntrctNOrdNo")), 30, " ");
				sItemID = StringUtils.rightPad(String.valueOf(map.get("bankDtlId")), 56, " ");
				sReservedA = StringUtils.rightPad("", 11, " ");
				sReservedB = StringUtils.rightPad("", 2, " ");
				sUnusedA = StringUtils.rightPad("", 8, " ");
				
				//암호화는 나중에 처리
				//sDrAccNo = EncryptionProvider.Decrypt(det.AccNo).Trim().PadRight(14, ' ');
				sDrAccNo = StringUtils.rightPad("34204542899", 14, " ");
				
				sDrName = ((String)map.get("bankDtlDrName")).length() > 40 ? 
									((String)map.get("bankDtlDrName")).trim().substring(0,40) : 
										StringUtils.rightPad((String)map.get("bankDtlDrName"), 40, " ");
									
				sNRIC = ((String)map.get("bankDtlDrNric")).length() > 16 ? 
								((String)map.get("bankDtlDrNric")).trim().substring(0,16) : 
									StringUtils.rightPad((String)map.get("bankDtlDrNric"), 16, " ");
				
				sLimit = ((java.math.BigDecimal)map.get("bankDtlAmt")).longValue()  * 100;
				iTotalAmt = iTotalAmt + sLimit;
				ihashtot3 = ihashtot3 + sLimit + Long.parseLong(sDrAccNo.trim());
				
				String debitAmount = StringUtils.leftPad(String.valueOf(sLimit), 13, "0");				
				sUnusedB = StringUtils.rightPad("",25, " ");
				
				stextDetails = "02" + sbatchNo + sDocno + sNRIC + sDrName + sDrAccNo + debitAmount + sReservedA + sReservedB + sUnusedA + sItemID;
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
			}    		
		}
		
		//footer 작성
		String sRecTot = StringUtils.leftPad(String.valueOf(claimDetailList.size()), 6, "0");
		String sBatchTot = StringUtils.leftPad(String.valueOf(iTotalAmt), 15, "0");
		String sHashTot = String.valueOf(ihashtot3);
		
		int endIndex = sHashTot.length() > 15 ? 15 : sHashTot.length();
		
		String sTextBtn = "";
		sTextBtn = "03" + sbatchNo + sRecTot + sBatchTot + StringUtils.rightPad("", 42, " ") + sHashTot.substring(0, endIndex)  + StringUtils.rightPad("", 112, " ");
		
		out.write(sTextBtn);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		//String emailTitle = "CIMB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	/**
	 * HLBB - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileHLBB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String sFile = "EPY1000991_" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyyyy") + ".csv";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/HLBB/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		int counter = 1;
		String stextDetails = "";
		String sdrname = "";
		String sdraccno = "";
		String samt = "";
		String sdocno = "";
		long fTotAmt = 0;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				sdrname = (String.valueOf(map.get("bankDtlDrName"))).length() > 40 ? 
									(String.valueOf(map.get("bankDtlDrName"))).substring(0,40) :
										StringUtils.rightPad(String.valueOf(map.get("bankDtlDrName")), 40, " ");

				//암호화는 나중에 하자
				//sdraccno = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim();
				sdraccno = "34204542899".trim();
        		 
				samt = StringUtils.leftPad(CommonUtils.getNumberFormat( String.valueOf(map.get("bankDtlAmt")), "0.00"), 12, "0");
				
				sdocno = (String.valueOf(map.get("cntrctNOrdNo"))).trim();
				stextDetails = StringUtils.leftPad(String.valueOf(counter), 3, "0") + 
                		 	",EPY1000991,HLBB," +
                		 	sdrname + "," + sdraccno + "," + samt + ",DR," + sdocno + "," + 
                		 	CommonUtils.changeFormat(CommonUtils.getAddDay(inputDate,1,"yyyy-MM-dd" ), "yyyy-MM-dd" , "ddMMyyyy");
                fTotAmt = fTotAmt + ((java.math.BigDecimal)map.get("bankDtlAmt")).longValue();
                
                out.write(stextDetails);
                out.newLine();
                out.flush();
                
                counter = counter + 1;
			}    		
		}
		
		//footer 작성
		String stext = "";
		String sbatchtot = StringUtils.leftPad(CommonUtils.getNumberFormat( String.valueOf(fTotAmt), "0.00"), 12, "0");
		String sbatchno = (CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy") + "01").trim();
		
		stext = StringUtils.leftPad(String.valueOf(counter), 3, "0") + 
        		 		",EPY1000991,HLBB," +
        		 		StringUtils.rightPad("WOONGJIN COWAY", 40, " ") +
        		 		",00100321782," + sbatchtot +
        		 		",CR," + sbatchno + "," + CommonUtils.changeFormat(CommonUtils.getAddDay(inputDate,1,"yyyy-MM-dd" ), "yyyy-MM-dd" , "ddMMyyyy");
         
        out.write(stext);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		//String emailTitle = "HLBB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	 
	/**
	 * MBB - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileMBB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String sFile = "ADSACC.txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/MBB/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String strHeader = "";
		String strHeader_Fix1 = "VOL1";
		String strHeader_Fix2 = "NN";
		String strHeader_OriginatorName = StringUtils.rightPad("WJIN COWAY", 13, " ");
		
		String strHeader_BillDate = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy");
		String strHeader_OriginatorID = "02172";
		String strHeader_BankUse = StringUtils.rightPad("", 50, " ");
		
		strHeader = strHeader_Fix1 + strHeader_Fix2 + strHeader_OriginatorName + strHeader_BillDate + 
							strHeader_OriginatorID + strHeader_BankUse;
         
		out.write(strHeader);
		out.newLine();
		out.flush();
		
		//본문 작성
		long iHashTot = 0;
		double iTotalAmt = 0;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				String strRecord = "";
				String strRecord_Fix = "00";
				
				//암호화는 나중에 하자
				//String strRecord_Acc = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadLeft(12, '0');
				String strRecord_Acc = StringUtils.leftPad("34204542899".trim(), 12, "0");
				
				String.valueOf(((java.math.BigDecimal) map.get("bankDtlAmt")).longValue() * 100);
				String strRecord_BillAmt = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal) map.get("bankDtlAmt")).longValue() * 100), 12, "0");
				
				String tmpStrRecord_NRIC = (String.valueOf(map.get("bankDtlDrNric"))).trim();
				String strRecord_NRIC = tmpStrRecord_NRIC.length() > 8 ? 
        				 CommonUtils.right(tmpStrRecord_NRIC, 8) :
        					 StringUtils.leftPad(tmpStrRecord_NRIC, 8, " ");
        		String strRecord_BankUse1 = StringUtils.leftPad("", 1, " ");
        		String strRecord_BillNo = StringUtils.leftPad(String.valueOf(map.get("cntrctNOrdNo")), 14, " ");        		
        		String strRecord_BankUse2 = StringUtils.leftPad("", 1, " ");
        		
        		
        		String tmpStrRecordPayer = (String.valueOf(map.get("bankDtlDrName"))).trim();
        		String strRecord_PayerName = tmpStrRecordPayer.length()  > 20 ? tmpStrRecordPayer.substring(0,20) : StringUtils.rightPad(tmpStrRecordPayer, 20, " ");
        		String strRecord_BankUse3 = StringUtils.leftPad("", 1, " ");
        		
        		strRecord = strRecord_Fix + strRecord_Acc + strRecord_BillAmt + strRecord_NRIC + 
                     strRecord_BankUse1 + strRecord_BillNo + strRecord_BankUse2 + strRecord_PayerName + 
                     strRecord_BankUse3;
        		
        		// 암호화는 나중에 하자
        		//iHashTot = iHashTot + Int64.Parse(CommonFunction.Right(EncryptionProvider.Decrypt(det.AccNo.Trim()),4));
        		iHashTot = iHashTot + Long.parseLong(CommonUtils.right("34204542899".trim(),4));
        		
        		iTotalAmt = iTotalAmt + ((java.math.BigDecimal)map.get("bankDtlAmt")).longValue();
        		
        		out.write(strRecord);
        		out.newLine();
        		out.flush();
			}    		
		}
		
		//footer 작성
		String strTrailer = "";
		String strTrailer_Fix = "FF";
		String strTrailer_TotalRecord = StringUtils.leftPad(String.valueOf(claimDetailList.size()), 12, "0");		
		String strTrailer_TotalAmount = StringUtils.leftPad(String.valueOf(iTotalAmt * 100), 12, "0");
		String strTrailer_TotalHash = StringUtils.leftPad(String.valueOf(iHashTot), 12, "0");
		String strTrailer_BankUse = StringUtils.rightPad("", 42, " ");
		
		strTrailer = strTrailer_Fix + strTrailer_TotalRecord + strTrailer_TotalAmount +
             strTrailer_TotalHash + strTrailer_BankUse;
        
		out.write(strTrailer);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String EmailTitle = "MBB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	 
	/**
	 *  PBB - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFilePBB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String sFile = "WCBPBB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyyyy") + "01.DIF";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/PBB/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String sText = "FH0001" + "3139835308" + 
				 		StringUtils.rightPad("PBB", 10, " ") + 
				 		CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "yyyyMMdd") +
				 		StringUtils.rightPad("WCBDEBIT", 20, " ") + 
				 		CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "yyyyMMdd") +
				 		StringUtils.rightPad("",138," ");
		
		out.write(sText);
		out.newLine();
		out.flush();
		
		//본문 작성
		String stextDetails = "";
		String sDocno = "";
		String sDrAccNo = "";
		String sDrName = "";
		String sNRIC = "";
		String sLimit = "";
		String sAmt = "";
		double iTotalAmt = 0;
		String sFiller = "";
		String sHashEntry = "";
		long iHashTot = 0;
		
		String trimAccNo = "";
		int startIdx = 0;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				sDocno = StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(), 20, " ");
				
				//암호화는 나중에 하자
				//sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim().PadRight(20,' ');
				sDrAccNo = StringUtils.rightPad("34204542899".trim(), 20, " ");
				
				String tmpSDrName = (String.valueOf(map.get("bankDtlDrName"))).trim();
				sDrName = tmpSDrName.length()  > 40 ? tmpSDrName.substring(0,40) : StringUtils.rightPad(tmpSDrName, 40, " ");
				sNRIC = StringUtils.rightPad(String.valueOf(map.get("bankDtlDrNric")), 20, " ");
				
				sLimit = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal)map.get("bankDtlAmt")).longValue() * 100), 12, "0");
				sAmt = StringUtils.leftPad(sLimit, 16, "0");
				
				iTotalAmt = iTotalAmt + Double.parseDouble(sLimit);
				
				sFiller = StringUtils.rightPad("", 87, " ");
				
				//substring을 위한 세팅 시작
				trimAccNo = sDrAccNo.trim();
				startIdx = trimAccNo.length() - 4 < 1 ? 0 : trimAccNo.length()-4;
				//substring을 위한 세팅 종료
				
				sHashEntry = String.valueOf((Integer.parseInt(sLimit) + Integer.parseInt(trimAccNo.substring(startIdx, trimAccNo.length()))));
				sHashEntry = StringUtils.leftPad(sHashEntry, 15, "0");
				
				stextDetails = "DT" + sDrAccNo + sAmt + sDrName + sDocno + sHashEntry + sFiller;
				iHashTot = iHashTot + Integer.parseInt(trimAccNo.substring(startIdx, trimAccNo.length()));
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
			}    		
		}
		
		//footer 작성
		String sTextBtn = "";
		sTextBtn = "FT0001" + "3139835308" + 
							StringUtils.rightPad("PBB", 10 , " ") +
        		 			StringUtils.leftPad(String.valueOf((claimDetailList.size() + 2)), 10 , "0") +
        		 			StringUtils.leftPad(String.valueOf(iTotalAmt), 20 , "0") +
        		 			StringUtils.leftPad(String.valueOf(iHashTot), 15 , "0") +        		 			
        		 			StringUtils.rightPad("", 129 , " ");
		
		out.write(sTextBtn);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();

		//메일 보내기는 나중에
		String EmailTitle = "PBB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
         
		/*********************************************
		 * Second file
		*********************************************/
		String sFile2nd = "WCBPBB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyyyy") + "01.DTR";
		
		//파일 디렉토리
		File file2nd = new File("C:/COWAY_PROJECT/TOBE/CRT/PBB/ClaimBank/" + sFile2nd);
		
		// 디렉토리 생성
		if (!file2nd.getParentFile().exists()) {
			file2nd.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter2nd = new FileWriter(file2nd);
		BufferedWriter out2nd = new BufferedWriter(fileWriter2nd);
		
		String count = StringUtils.leftPad(String.valueOf((claimDetailList.size() + 2)), 6, " ");		
		String iTotalAmtStr = StringUtils.leftPad(CommonUtils.getNumberFormat( String.valueOf(iTotalAmt / 100), "###,###,###.00"), 13, " ");
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("                                                         PAGE: 1").append("\n");
		sb.append("                                                         REPORT DATE: " + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "dd/MM/yyyyd")).append("\n");
		sb.append("").append("\n");
		sb.append("                           WOONGJIN COWAY (M) SDN BHD").append("\n");
		sb.append("                   TRANSMITTAL REPORT OF DIRECT DEBIT RECORDS").append("\n");
		sb.append("                              FOR PUBLIC BANK BERHAD").append("\n");
		sb.append("").append("\n");
		sb.append("").append("\n");
		sb.append("DEDUCTION DATE: " + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "dd/MM/yyyy")).append("\n");
		sb.append("").append("\n");
		sb.append("           COUNT       AMOUNT").append("\n");
		sb.append("          -------------------").append("\n");
		sb.append("TOTAL:    " + count + iTotalAmtStr).append("\n");
		sb.append("").append("\n");
		
		out2nd.write(sb.toString());
 		out2nd.newLine();
 		out2nd.flush();
 		 
 		out2nd.close();
 		fileWriter2nd.close();
 		
 		// 메일 보내기는 나중에
 		EmailTitle = "PBB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
 		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	
	
	private long intamtinh = 0;
	private long intaccinh = 0;
	
	/**
	 * RHB - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileRHB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
		String sFile = "AB_00035_Datafile_" + todayDate + "_001.txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/RHB/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String sText = "";
		sText = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyyyy") +
        		 	"00035" + "061" + "001" + "0" + "21413800109431" +
        		 StringUtils.rightPad("", 16, " ") + 
        		 StringUtils.rightPad("WOONGJIN COWAY", 35, " ") +
        		 StringUtils.rightPad("735420-H", 12, " ") +
        		 StringUtils.rightPad("", 303, " ");
         
		out.write(sText);
		out.newLine();
		out.flush();
		
		//본문 작성
		String stextDetails = "";
		String sDrAccNo = "";
		String sDrName = "";
		String sLimit = "";
		String sDocno = "";
		long iHashTot = 0;
		double iTotalAmt = 0;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				//암호화는 나중에 하자
				//sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadLeft(14,' ');
				sDrAccNo = StringUtils.leftPad("34204542899".trim(), 14, " ");
				
				sDrName =  (String.valueOf(map.get("bankDtlDrName"))).trim().length() > 35 ? 
                		 			(String.valueOf(map.get("bankDtlDrName"))).trim().substring(0,35) :                	 
                		 				StringUtils.rightPad((String.valueOf(map.get("bankDtlDrName"))).trim(), 35, " ");
                		 			
                sLimit = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal)map.get("bankDtlAmt")).longValue() * 100), 15, "0");
                sDocno = StringUtils.rightPad((String.valueOf(map.get("cntrctNOrdNo"))).trim(), 20, "0");
                iHashTot = this.CalculateCheckSum_RHB(((java.math.BigDecimal)map.get("bankDtlAmt")).longValue(), sDrAccNo.trim(), iHashTot);
                iTotalAmt = iTotalAmt + Double.parseDouble(sLimit.trim());                 
                stextDetails = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyyyy") +                 
                		 			"00035" + "061" + "001" + "1" + sDrAccNo +                		 
                		 			StringUtils.rightPad("", 16, " ") +
                		 			sDrName + 
                		 			StringUtils.rightPad("", 12, " ") + 
                		 			sLimit + sDocno + 
                		 			StringUtils.rightPad("", 10, " ") + 
                		 			StringUtils.rightPad("0", 15, " ") + 
                		 			StringUtils.rightPad("0", 15, " ") + StringUtils.rightPad("", 7, " ") + StringUtils.rightPad("0", 15, " ") +
                		 			StringUtils.rightPad("", 16, " ") + 
                		 			String.valueOf(intamtinh) + 
                		 			StringUtils.rightPad("", 5, " ") +
                		 			String.valueOf(intaccinh) + 
                		 			StringUtils.rightPad( "", 190, " ");
                 
        		out.write(stextDetails);
        		out.newLine();
        		out.flush();
			}    		
		}
		
		//footer 작성
		String sTextBtn = "";
		sTextBtn =  CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyyyy") + "00035" + "061" + "001" + "9" + "21413800109431" +
        		 StringUtils.rightPad("", 16, " ") + 
        		 StringUtils.leftPad(String.valueOf(iTotalAmt), 15, "0") +
        		 StringUtils.leftPad(String.valueOf(claimDetailList.size()), 12, "0") + 
        		 StringUtils.leftPad(String.valueOf(iHashTot), 16, "0") +
        		 StringUtils.rightPad("0", 15, "0") +
        		 StringUtils.rightPad("",292," ");
        
		out.write(sTextBtn);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		//String emailTitle = "RHB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	 
	/**
	 * 
	 * @param amt
	 * @param accNo
	 * @param iHashTot
	 * @return
	 */
	private long CalculateCheckSum_RHB(long amt, String accNo, long iHashTot) {
		long iAmt64 = 0;
		long iAcc64 = 0;
		
		iAmt64 = Long.parseLong(String.valueOf(amt * 100));		
		iAcc64 = accNo.length() > 8 ? Long.parseLong(CommonUtils.right(accNo,  8)) : Long.parseLong(accNo.trim());
		
		intamtinh = iAmt64;
		intaccinh = iAcc64;
		
		return (iAmt64 * iAcc64) + iHashTot;
	}
	 
	/**
	 * BSN - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileBSN(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String todayDate = CommonUtils.getNowDate();
		String sFile = "BSN" + todayDate + "B01.txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/BSN/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		 
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String sText = "";
		String sorigid = "M4743600";
		String senrdate = todayDate;
		String sorgacc = "1410029000510851";
		sText = sorigid + senrdate + "29755" + "0000000" + sorgacc + StringUtils.leftPad("", 76, " ");
		
		out.write(sText);
		out.newLine();
		out.flush();
		
		//본문 작성
		int counter = 1;
		long iHashTot = 0;
		String stextDetails = "";
		String sLimit = "";
		String sDrAccNo = "";
		String sDocno = "";
		String sNRIC = "";
		String sMNric = "";
		double iTotalAmt = 0;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				sLimit = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal)map.get("bankDtlAmt")).longValue() * 100), 15, "0");
				
				//암호화는 나중에 하자
				//sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadRight(16,' ');
				sDrAccNo = StringUtils.leftPad("34204542899".trim(), 16, " ");
				
				sDocno = StringUtils.rightPad(String.valueOf(map.get("cntrctNOrdNo")), 20, " ");				
				sNRIC = StringUtils.rightPad(String.valueOf(map.get("bankDtlDrNric")), 12, " ");
				
				if(sNRIC.trim().length() != 12){
					sMNric =   (String.valueOf(map.get("bankDtlDrNric"))).trim().length() > 8 ?
     			 			(String.valueOf(map.get("bankDtlDrNric"))).trim().substring(0,8) :
     			 				StringUtils.rightPad((String.valueOf(map.get("bankDtlDrNric"))).trim(), 8, " ");
				}
				
				iTotalAmt = iTotalAmt + ((java.math.BigDecimal)map.get("bankDtlAmt")).doubleValue();
				
				if ((String.valueOf(map.get("bankDtlDrNric"))).trim().length() == 12){
					stextDetails = sorigid + senrdate + "29755" + 
                    		 				StringUtils.leftPad(String.valueOf(counter), 7, "0") + sLimit +                         
                    		 				sDrAccNo + "A100" + StringUtils.rightPad("", 4, " ") + sDocno + StringUtils.rightPad("", 12, " ") + sNRIC + StringUtils.rightPad("", 8, " ") + " ";                     
				} else {
					stextDetails = sorigid + senrdate + "29755" + StringUtils.leftPad(String.valueOf(counter), 7, "0") + sLimit +
                         sDrAccNo + "A100" + StringUtils.rightPad("", 4, " ")
                         + sDocno + StringUtils.rightPad("", 12, " ") + StringUtils.rightPad("", 12, " ") + sMNric + " ";
				}
				
				iHashTot = iHashTot + Long.parseLong(CommonUtils.right(sDrAccNo.trim(),4));
				
				out.write(stextDetails);
				out.newLine();
				out.flush();
				
				counter = counter +1;
			}    		
		}
		
		//footer 작성
		sText = sorigid + senrdate + "29755" + "9999999" + 
        		 	StringUtils.leftPad(String.valueOf(iTotalAmt * 100), 15, "0") +
        		 	StringUtils.leftPad(String.valueOf(claimDetailList.size() + 2), 9, "0") +
        		 	StringUtils.leftPad(String.valueOf(iHashTot % 10000), 4, "0") +
        		 	StringUtils.rightPad("", 64, " ");
        
		out.write(sText);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String EmailTitle = "BSN Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	 
	 
	/**
	 * My Clear - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileMyClear(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String todayDate = CommonUtils.getNowDate();
		String sFile = "MyClear_Billing_" + todayDate + ".txt";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/MyClear/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String strHeader = "";
		String strHeader_CountryCode= "MY";
		String strHeader_BranchCode = StringUtils.rightPad("950", 5, " ");
		String strHeader_BranchDivision =StringUtils.rightPad(String.valueOf(claimMap.get("ctrlId")), 10, " ");
		String strHeader_Account = StringUtils.rightPad("117192008", 30, " ");		
		String strHeader_UnusedrSpaces = StringUtils.rightPad("", 30, " ");
		
		strHeader = strHeader_CountryCode + strHeader_BranchCode + strHeader_BranchDivision + strHeader_Account + strHeader_UnusedrSpaces;
		
		out.write(strHeader);
		out.newLine();
		out.flush();
		
		//본문 작성
		double iTotalAmt = 0;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				String strRecordType = "DDI";
				String strRecordTransactionType = StringUtils.rightPad("87", 4, " ");
				String strRecordRefNo = StringUtils.rightPad(String.valueOf(map.get("cntrctNOrdNo")), 20, " ");
				
				//암호화는 나중에 하자
				//String strRecordAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadRight(30, ' ');
				String strRecordAccNo = StringUtils.rightPad((String.valueOf("34204542899")).trim(), 30, " ");
				
				String strRecordBankCode = StringUtils.rightPad((String.valueOf(map.get("Bic"))).trim(), 16, " ");				
				String strRecordBranch = StringUtils.rightPad("", 5, " ");				
				String strRecordPayerName = (String.valueOf(map.get("bankDtlDrName"))).trim().length() > 70 ?
                		 (String.valueOf(map.get("bankDtlDrName"))).trim().substring(0,70) :
                			 StringUtils.rightPad((String.valueOf(map.get("bankDtlDrName"))).trim(), 70, " ");
                String strRecordPayerCode = (String.valueOf(map.get("bankDtlDrNric"))).trim().length() > 20 ? 
                		 (String.valueOf(map.get("bankDtlDrNric"))).trim().substring(0,20) :
                			 StringUtils.rightPad((String.valueOf(map.get("bankDtlDrNric"))).trim(), 20, " ");
                String strRecordBillAmt = StringUtils.leftPad(CommonUtils.getNumberFormat( String.valueOf(map.get("bankDtlAmt")), "0.00"), 16, "0");
                String strRecordBillDate = CommonUtils.changeFormat(String.valueOf(map.get("bankDtlDrDt")), "yyyy-MM-dd", "ddMMyyyy");
                String strRecordPayerEmail = StringUtils.rightPad("", 50, " ");
                String strRecordPayerPhone = StringUtils.rightPad("", 15, " ");
                String strRecordPayerFax = StringUtils.rightPad("", 15, " ");
                String strRecordPaymentRef1 = StringUtils.rightPad("", 35, " ");
                String strRecordPaymentRef2 = StringUtils.rightPad("", 140, " ");
                String strRecordPaymentRef3 = StringUtils.rightPad("", 140, " ");
                String strRecordUnusedSpaces = StringUtils.rightPad("", 30, " ");

                String strRecord = "";

                strRecord = strRecordType + strRecordTransactionType + strRecordRefNo + strRecordAccNo +
                     strRecordBankCode + strRecordBranch + strRecordPayerName + strRecordPayerCode + strRecordBillAmt +
                     strRecordBillDate + strRecordPayerEmail + strRecordPayerPhone + strRecordPayerFax + strRecordPaymentRef1 +
                     strRecordPaymentRef2 + strRecordPaymentRef3  + strRecordUnusedSpaces;

                iTotalAmt = iTotalAmt + ((java.math.BigDecimal)map.get("bankDtlAmt")).doubleValue();
                 
        		out.write(strRecord);
        		out.newLine();
        		out.flush();
			}    		
		}
		
		//footer 작성
		String strTrailer = "";
		String strTrailer_TotalRecord = StringUtils.leftPad(String.valueOf(claimDetailList.size()), 8, "0");
		String strTrailer_UnusedSpaces = StringUtils.rightPad("0", 8, "0");		
		String strTrailer_TotalAmount = StringUtils.leftPad(CommonUtils.getNumberFormat( String.valueOf(iTotalAmt), "0.00"), 16, "0");
		String strTrailer_UnusedSpaces2 = StringUtils.rightPad("", 30, " ");
		
		strTrailer = strTrailer_TotalRecord + strTrailer_UnusedSpaces + strTrailer_TotalAmount + strTrailer_UnusedSpaces2;
		
		out.write(strTrailer);
		out.newLine();
		out.flush();
		out.close();
		fileWriter.close();
		
		// 메일 보내기는 나중에
		String EmailTitle = "MyClear Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
		//SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
	 
	 
	/**
	 *  CRC CIMB - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileCrcCIMB(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
		
		int RowNo = 0;
		int FileNo = 1;
		int RowBalance = claimDetailList.size();
		String stext = "";
		
		File file = null;
		FileWriter fileWriter = null;
		BufferedWriter out = null;
		
		if (claimDetailList.size() > 0) {
			for(int i = 0 ; i < claimDetailList.size() ; i++){
				Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
				
				if(RowNo == 0){
					//파일 디렉토리
					file = new File("C:/COWAY_PROJECT/TOBE/CRC/CRC_" + todayDate + "_" + FileNo + ".csv");
					
					if (!file.getParentFile().exists()) {
						file.getParentFile().mkdirs();
					}
					
					fileWriter = new FileWriter(file);
					out = new BufferedWriter(fileWriter);
				}
				
				String CrcOwner = (String.valueOf(map.get("bankDtlDrName"))).trim();
				
				//암호화는 나중에 하자
				//String CrcNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim();
				String CrcNo = "34204542899".trim();
				
				String CrcExpiry = "0000";
                String Amount = CommonUtils.getNumberFormat(String.valueOf(map.get("bankDtlAmt")),  "0.00");
                String ServiceCode = String.valueOf(map.get("cntrctNOrdNo"));
                String Remarks = String.valueOf(map.get("bankDtlId"));
                 
                stext = CrcOwner + "," + CrcNo + "," + CrcExpiry + ",$"  + Amount + "," + ServiceCode + "," + Remarks;
                 
                out.write(stext);
        		out.newLine();
        		out.flush();
        		 
                RowNo = RowNo + 1;
                RowBalance = RowBalance - 1;
                 
                if (RowNo == 10000 || RowBalance == 0){
                	out.close();
                	fileWriter.close();
                	
                	RowNo = 0;
                	FileNo = FileNo + 1;
                }
                
                // 메일 보내기는 나중에
                String EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
                //SendEmailAutoDebitDeduction(EmailTitle, Location);
        		         		
			}    		
		}		 
	}
	 
	/**
	 *  FPX - Create Claim File
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileFPX(EgovMap claimMap, List<EgovMap> claimDetailList) throws Exception{
		
		String inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String)claimMap.get("ctrlBatchDt");
		String sFile = "CFT" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + "SE00000293" + "01.dat";
		
		//파일 디렉토리
		File file = new File("C:/COWAY_PROJECT/TOBE/CRT/FPX/ClaimBank/" + sFile);
		
		// 디렉토리 생성
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
				
		FileWriter fileWriter = new FileWriter(file);
		BufferedWriter out = new BufferedWriter(fileWriter);
		
		/***********************************************
		 *  파일 내용 쓰기
		 ************************************************/
		//헤더 작성
		String stext = "";
		stext = "1" + StringUtils.rightPad("FPX", 6, " ") +
        		 	CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "dd/MM/yyyy") +
        		 	"SE00000293" + "99";
         
         
		out.write(stext);
		out.newLine();
		out.flush();
		 
        //본문 작성
		String sdocno = "";
		String sCrAccNo = "";
		String sDRBankID = "";
		String sdrbankBr = "";
		String sDrAccNo = "";
		String sDrName = "";
		String sNRIC = "";
		String samt = "";
        double itotamt = 0;
        long ihashVal = 0;
        long ihashtot = 0;
         
        if (claimDetailList.size() > 0) {
        	for(int i = 0 ; i < claimDetailList.size() ; i++){
        		Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
        		
        		sdocno = StringUtils.rightPad(String.valueOf(map.get("cntrctNOrdNo")), 20, " ");
                sCrAccNo = StringUtils.leftPad("21413800109431", 20, " ");
                sDRBankID = StringUtils.rightPad(String.valueOf(map.get("fpxCode")), 10, " ");
                sdrbankBr = StringUtils.leftPad("111", 10, " ");
                 
                //암호화는 나중에 하자
                //sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim().PadLeft(20,' ');
                sDrAccNo = StringUtils.leftPad("34204542899".trim(), 20, " ");
                 
                sDrName =  (String.valueOf(map.get("bankDtlDrName"))).trim().length() > 40 ?
                		 			(String.valueOf(map.get("bankDtlDrName"))).trim().substring(0,40) :
                		 				StringUtils.rightPad((String.valueOf(map.get("bankDtlDrName"))).trim(), 40, " ");
                		 
                sNRIC =  (String.valueOf(map.get("bankDtlDrNric"))).trim().length() > 20 ?
                		 (String.valueOf(map.get("bankDtlDrNric"))).trim().substring(0,20) :
                			 	StringUtils.rightPad((String.valueOf(map.get("bankDtlDrNric"))).trim(), 20, " ");
                		 
                samt = StringUtils.leftPad(CommonUtils.getNumberFormat(String.valueOf(map.get("bankDtlAmt")),  "0.00"), 12, " ");
                 
                stext = "2" + sdocno + sCrAccNo + sDRBankID + sdrbankBr + sDrAccNo + sDrName + "1" +
                      sNRIC + samt + "MYR" + StringUtils.rightPad("", 91, " ") + "99";
                
                itotamt = itotamt + (((java.math.BigDecimal)map.get("bankDtlAmt")).doubleValue() * 100);                 
                 
                ihashVal = (Long.parseLong(CommonUtils.right(sDrAccNo.trim(), 8)) * 
                		 			Long.parseLong(String.valueOf(((java.math.BigDecimal)map.get("bankDtlAmt")).longValue() * 100)));
                ihashtot = ihashtot + Long.parseLong((CommonUtils.right(String.valueOf(ihashVal), 8)));
                 
                out.write(stext);
        		out.newLine();
        		out.flush();
        	}    		
        }
         
        //footer 작성
        stext = "9" + StringUtils.leftPad(String.valueOf(claimDetailList.size()), 6, " ") +
        					StringUtils.leftPad(String.valueOf(itotamt), 15, " ") +
        						StringUtils.leftPad((String.valueOf(ihashtot)).trim(), 13, " ");
        
        out.write(stext);
		out.newLine();
		out.flush();
        out.close();
        fileWriter.close();

		// 메일 보내기는 나중에
        String EmailTitle = "FPX Auto Debit Claim File - Batch Date" + CommonUtils.nvl(claimMap.get("ctrlBatchDt"));
        //SendEmailAutoDebitDeduction(EmailTitle, Location);
	}
}
