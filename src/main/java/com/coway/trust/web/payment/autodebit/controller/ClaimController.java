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

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;
	
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
		logger.debug("ctrlIsCrc : {}", claimMap.get("ctrlIsCrc"));
		
		
		
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
				System.out.println("##################### CREATE BANK FILE RHB");
				
			}
			
			//BSN
			if("9".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				System.out.println("##################### CREATE BANK FILE BSN");
			}
			
			//My Clear
			if("46".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				System.out.println("##################### CREATE BANK FILE MY CLEAR");
			}
			
			
		}else if("1".equals(((java.math.BigDecimal) claimMap.get("ctrlIsCrc")).toString())){
			System.out.println("##################### CREATE BANK FILE 1");
			
		}else if("134".equals(((java.math.BigDecimal) claimMap.get("ctrlIsCrc")).toString())){
			System.out.println("##################### CREATE BANK FILE 134");
			
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
		  ************************************************/
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
        		 sDrAccNo = CommonUtils.getFillString("34204542899", " ",15, "RIGHT");
        		 
        		 
                 sLimit = CommonUtils.getNumberFormat( String.valueOf(map.get("bankDtlAmt")), "#,##0.00");
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
         sTextBtn = "T|" + claimDetailList.size() + "|" + CommonUtils.getNumberFormat( iTotalAmt, "#,##0.00") +"|";         
         
         out.write(sTextBtn);
		 out.newLine();
		 out.flush(); 
		 out.close();

		 // 메일 보내기는 나중에
         //Stringstring EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + batchCtrl.CtrlBatDate.Value.ToShortDateString();
         //SendEmailAutoDebitDeduction(EmailTitle, Location);
		 
		 
	 }
	 
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

         String HeaderStr = hRecordType + "|" + hCreditAccNo + "|" + hCompanyName + "|" + hFileBatchRefNo + "|" + hCollectionDate + "|" +
             hSellerID + "|" + hCreditType + "|";      
        		 
		 out.write(HeaderStr);
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
         String MobNo = "";
         String Email1 = "";
         String Email2 = "";
         
         if (claimDetailList.size() > 0) {
        	 for(int i = 0 ; i < claimDetailList.size() ; i++){
        		 Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
        		 
        		 //암호화는 나중에 하자
        		 //string AccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).ToString().Trim();
        		 String AccNo = "34204542899".trim();        		 
        		 
                 String AccNRIC = ((String)map.get("bankDtlDrNric")).trim();
                 dDebtiAccNo = AccNo.length() > 17 ? AccNo.substring(0, 17) : AccNo;
                 dDebitAccName = ((String)map.get("bankDtlDrName")).length() > 40 ? ((String)map.get("bankDtlDrName")).substring(0, 40) : (String)map.get("bankDtlDrName");
                 dCollAmt = CommonUtils.getNumberFormat( String.valueOf(map.get("bankDtlAmt")), "#,##0.00");
                 dOrderNo = (String)map.get("cntrctNOrdNo"); 
                 dSellerInternalRefNo = 
                		 String.valueOf(map.get("bankDtlId")).length() > 40 ? 
                				 (String.valueOf(map.get("bankDtlId"))).substring(0, 40) : 
                					 String.valueOf(map.get("bankDtlId"));                 

                 if (AccNRIC.length() == 12)
                     dBuyerNewICNo = AccNRIC;
                 else if (AccNRIC.length() == 8)
                     dBuyerOldICNo = AccNRIC;
                 else
                     dBuyerBusinessRegNo = AccNRIC;
                 
                 String DetailStr = dRecordType + "|" + dDebtiAccNo + "|" + dDebitAccName + "|" + dBankCode + "|" +
                     dCollAmt + "|" + dOrderNo + "|" + dSellerInternalRefNo + "|" + dBuyerNewICNo + "|" +
                     dBuyerOldICNo + "|" + dBuyerBusinessRegNo + "|" + dBuyerOtherIDValue + "|" + dNotiReq + "|" +
                     MobNo + "|" + Email1 + "|" + Email2  + "|";
                 
                 out.write(DetailStr);
        		 out.newLine();
        		 out.flush();
        		 
        		 totalCollection +=  ((java.math.BigDecimal)map.get("bankDtlAmt")).longValue();
        		 hashTotal += Long.parseLong((dDebtiAccNo.substring(dDebtiAccNo.length() - 10 < 1 ? 0 : dDebtiAccNo.length() - 10, dDebtiAccNo.length())));
        	 }    		
         }
         
         //footer 작성
         String tRecordType = "T";
         String tTotalRecord = String.valueOf(claimDetailList.size());
         String tTotalCollectionAmt = CommonUtils.getNumberFormat( totalCollection, "#,##0.00");
         String tmpHashTotal = 	 (CommonUtils.getNumberFormat( hashTotal, "0000"));
         String tHashTotal = tmpHashTotal.substring(tmpHashTotal.length() - 10 < 1 ? 0 : tmpHashTotal.length() - 10, tmpHashTotal.length());
         String TrailerStr = "";
         TrailerStr = tRecordType + "|" + tTotalRecord + "|" + tTotalCollectionAmt + "|"  + tHashTotal + "|";
         
         out.write(TrailerStr);
		 out.newLine();
		 out.flush();        
		 out.close();

		 // 메일 보내기는 나중에
         //Stringstring EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + batchCtrl.CtrlBatDate.Value.ToShortDateString();
         //SendEmailAutoDebitDeduction(EmailTitle, Location);
		 
		 
	 }
	 
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
		 String sSecCode = CommonUtils.getFillString(String.valueOf((Integer.parseInt(sbatchNo) + 1208083646)), " ", 10, "RIGHT");
		 String sText = "01" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy") + "01" + "2120" + CommonUtils.getFillString("WOONGJIN COWAY", " ", 40, "") +
        		 CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy") + sSecCode + CommonUtils.getFillString("", " ",128, "");
        		 
		 out.write(sText);
		 out.newLine();
		 out.flush(); 
        
		 //본문 작성
         String stextDetails = "";
         String sDocno = "";
         String sNRIC = "";
         String sDrName = "";
         String sDrAccNo = "";
         //Ben-20150416
         String sItemID = "";
         String sReservedA = "";
         String sReservedB = "";
         String sUnusedA = "";
         String sUnusedB = "";
         //EndHere
         long sLimit = 0;
         long iTotalAmt = 0;
         long ihashtot3 = 0;
         
         if (claimDetailList.size() > 0) {
        	 for(int i = 0 ; i < claimDetailList.size() ; i++){
        		 Map<String, Object> map = (Map<String, Object>)claimDetailList.get(i);
        		 
        		 sDocno = CommonUtils.getFillString(map.get("cntrctNOrdNo"), " ",30, "");
                 sItemID = CommonUtils.getFillString(map.get("bankDtlId"), " ",56, "");
                 sReservedA = CommonUtils.getFillString("", " ",11, "");
                 sReservedB = CommonUtils.getFillString("", " ",2, "");
                 sUnusedA = CommonUtils.getFillString("", " ",8, "");
                 
                 //암호화는 나중에 처리
                 //sDrAccNo = EncryptionProvider.Decrypt(det.AccNo).Trim().PadRight(14, ' ');
                 sDrAccNo = CommonUtils.getFillString("34204542899", " ",14, "");
                                
                 sDrName = ((String)map.get("bankDtlDrName")).length() > 40 ? ((String)map.get("bankDtlDrName")).trim().substring(0,40) : CommonUtils.getFillString((String)map.get("bankDtlDrName")," " ,40,"") ;
                 sNRIC = ((String)map.get("bankDtlDrNric")).length() > 16 ? ((String)map.get("bankDtlDrNric")).trim().substring(0,16) : CommonUtils.getFillString((String)map.get("bankDtlDrNric")," " ,16,"") ;
                 
                 sLimit = ((java.math.BigDecimal)map.get("bankDtlAmt")).longValue()  * 100;
                 iTotalAmt = iTotalAmt + sLimit;
                 ihashtot3 = ihashtot3 + sLimit + Long.parseLong(sDrAccNo.trim());
                
                 String debitAmount = CommonUtils.getFillString(sLimit, "0",13, "RIGHT");
                 sUnusedB = CommonUtils.getFillString("", " ",25, "");

                 stextDetails = "02" + sbatchNo + sDocno + sNRIC + sDrName + sDrAccNo + debitAmount + sReservedA + sReservedB + sUnusedA + sItemID;
                 
                 out.write(stextDetails);
        		 out.newLine();
        		 out.flush();
        	 }    		
         }
         
         //footer 작성
         String sRecTot = CommonUtils.getFillString(claimDetailList.size(), "0",6, "RIGHT");
         String sBatchTot = CommonUtils.getFillString(iTotalAmt, "0",15, "RIGHT");
         String sHashTot = String.valueOf(ihashtot3);
         
         int endIndex = sHashTot.length() > 15 ? 15 : sHashTot.length();         
      		 
         String sTextBtn = "";
         sTextBtn = "03" + sbatchNo + sRecTot + sBatchTot + CommonUtils.getFillString("", " ",42, "") + sHashTot.substring(0, endIndex)  + CommonUtils.getFillString("", " ",112, "");
         
         out.write(sTextBtn);
		 out.newLine();
		 out.flush(); 
		 out.close();

		 // 메일 보내기는 나중에
         //Stringstring EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + batchCtrl.CtrlBatDate.Value.ToShortDateString();
         //SendEmailAutoDebitDeduction(EmailTitle, Location);
	 }
	 
	 
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
        		 
        		 sdrname = 
        		 (String.valueOf(map.get("bankDtlDrName"))).length() > 40 ?
        				 (String.valueOf(map.get("bankDtlDrName"))).substring(0,40) :
        					 CommonUtils.getFillString(String.valueOf(map.get("bankDtlDrName")) , " ",40, "");

        		 //암호화는 나중에 하자
        		 //sdraccno = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim();
        		 sdraccno = "34204542899".trim();
        		 
        		 samt = CommonUtils.getFillString(CommonUtils.getNumberFormat( String.valueOf(map.get("bankDtlAmt")), "#,##0.00") , "0",12, "RIGHT");
                 sdocno = (String.valueOf(map.get("cntrctNOrdNo"))).trim();
                 stextDetails = CommonUtils.getFillString(String.valueOf(counter) , "0",3, "RIGHT") + 
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
         String sbatchtot = CommonUtils.getFillString(CommonUtils.getNumberFormat( String.valueOf(fTotAmt), "#,##0.00") , "0",12, "RIGHT");         
         String sbatchno = (CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy") + "01").trim();

         stext = CommonUtils.getFillString(String.valueOf(counter) , "0",3, "RIGHT") + 
        		 		",EPY1000991,HLBB," +
        		 		CommonUtils.getFillString("WOONGJIN COWAY" , " ",40, "") +
        		 		",00100321782," + sbatchtot +
        		 		",CR," + sbatchno + "," + CommonUtils.changeFormat(CommonUtils.getAddDay(inputDate,1,"yyyy-MM-dd" ), "yyyy-MM-dd" , "ddMMyyyy");
         
         
        
         out.write(stext);
		 out.newLine();
		 out.flush();
         out.close();

		 // 메일 보내기는 나중에
         //Stringstring EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + batchCtrl.CtrlBatDate.Value.ToShortDateString();
         //SendEmailAutoDebitDeduction(EmailTitle, Location);
	 }
	 
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
		 String strHeader_OriginatorName = CommonUtils.getFillString("WJIN COWAY" , " ",13, "");
		 String strHeader_BillDate = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "ddMMyy");
		 String strHeader_OriginatorID = "02172";
		 String strHeader_BankUse = CommonUtils.getFillString("" , " ",50, "");
		 
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
        		 String strRecord_Acc = CommonUtils.getFillString("34204542899".trim() , "0",12, "RIGHT");
        		 
        		 String.valueOf(((java.math.BigDecimal) map.get("bankDtlAmt")).longValue() * 100);
        		 String strRecord_BillAmt = CommonUtils.getFillString(String.valueOf(((java.math.BigDecimal) map.get("bankDtlAmt")).longValue() * 100), "0" , 12 , "RIGHT");
        		 String tmpStrRecord_NRIC = (String.valueOf(map.get("bankDtlDrNric"))).trim();
        		 String strRecord_NRIC = tmpStrRecord_NRIC.length() > 8 ? 
        				 tmpStrRecord_NRIC.substring(tmpStrRecord_NRIC.length() - 8 < 1 ? 0 : tmpStrRecord_NRIC.length() - 8, tmpStrRecord_NRIC.length()) :
        					 CommonUtils.getFillString(tmpStrRecord_NRIC, " " , 8 , "");		         		 
        		 String strRecord_BankUse1 = CommonUtils.getFillString("", " " , 1 , "");
        		 String strRecord_BillNo = CommonUtils.getFillString(String.valueOf(map.get("cntrctNOrdNo")), " " , 14 ,"");
        		 String strRecord_BankUse2 = CommonUtils.getFillString("", " " , 1 , "");
        		 String tmpStrRecordPayer = (String.valueOf(map.get("bankDtlDrName"))).trim();
        		 String strRecord_PayerName = tmpStrRecordPayer.length()  > 20 ? tmpStrRecordPayer.substring(0,20) : CommonUtils.getFillString(tmpStrRecordPayer, " " , 20 , "");
        		 
        		 String strRecord_BankUse3 = CommonUtils.getFillString("", " " , 1 , "");
                 strRecord = strRecord_Fix + strRecord_Acc + strRecord_BillAmt + strRecord_NRIC + 
                     strRecord_BankUse1 + strRecord_BillNo + strRecord_BankUse2 + strRecord_PayerName + 
                     strRecord_BankUse3;
                 
                 // 암호화는 나중에 하자 
                 //iHashTot = iHashTot + Int64.Parse(CommonFunction.Right(EncryptionProvider.Decrypt(det.AccNo.Trim()),4));
                 iHashTot = iHashTot + Long.parseLong(("34204542899".trim()).substring(("34204542899".trim()).length() - 4 < 1 ? 0 : ("34204542899".trim()).length() - 4 , ("34204542899".trim()).length()));
                 
                 iTotalAmt = iTotalAmt + ((java.math.BigDecimal)map.get("bankDtlAmt")).longValue();
                 
                 out.write(strRecord);
        		 out.newLine();
        		 out.flush();
        	 }    		
         }
         
         
         //footer 작성
         String strTrailer = "";
         String strTrailer_Fix = "FF";
         String strTrailer_TotalRecord = CommonUtils.getFillString(String.valueOf(claimDetailList.size()), "0" , 12 , "RIGHT");
         String strTrailer_TotalAmount = CommonUtils.getFillString(String.valueOf(iTotalAmt * 100), "0" , 12 , "RIGHT");
         String strTrailer_TotalHash = CommonUtils.getFillString(String.valueOf(iHashTot), "0" , 12 , "RIGHT");         
         String strTrailer_BankUse = CommonUtils.getFillString("", " " , 42 , "");
         
         strTrailer = strTrailer_Fix + strTrailer_TotalRecord + strTrailer_TotalAmount +
             strTrailer_TotalHash + strTrailer_BankUse;
        
         out.write(strTrailer);
		 out.newLine();
		 out.flush();
         out.close();

		 // 메일 보내기는 나중에
         //Stringstring EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + batchCtrl.CtrlBatDate.Value.ToShortDateString();
         //SendEmailAutoDebitDeduction(EmailTitle, Location);
	 }
	 
	 
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
				 		CommonUtils.getFillString("PBB", " " , 10 , "") +		 
				 		CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "yyyyMMdd") +
				 		CommonUtils.getFillString("WCBDEBIT", " " , 20 , "") +
				 		CommonUtils.changeFormat(inputDate, "yyyy-MM-dd" , "yyyyMMdd") +  
				 		CommonUtils.getFillString("", " " , 138 , "");
	     
         
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
        		 

                 sDocno = CommonUtils.getFillString((String.valueOf(map.get("cntrctNOrdNo"))).trim(), " " , 20 , "");
                 
                 //암호화는 나중에 하자
                 //sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim().PadRight(20,' ');
                 sDrAccNo = CommonUtils.getFillString("34204542899".trim() , " ",20, "");
                 
                 String tmpSDrName = (String.valueOf(map.get("bankDtlDrName"))).trim();
                 sDrName = tmpSDrName.length()  > 40 ? tmpSDrName.substring(0,40) : CommonUtils.getFillString(tmpSDrName, " " , 40 , "");
                 sNRIC = CommonUtils.getFillString(String.valueOf(map.get("bankDtlDrNric")), " " , 20 , "");
                 sLimit = CommonUtils.getFillString(String.valueOf(((java.math.BigDecimal)map.get("bankDtlAmt")).longValue() * 100), "0" , 12 , "RIGHT");
                 sAmt = CommonUtils.getFillString(sLimit, "0" , 16 , "RIGHT");
                 
                 iTotalAmt = iTotalAmt + Double.parseDouble(sLimit);
                 
                 sFiller = CommonUtils.getFillString("", " " , 87 , "");
                 
                 //substring을 위한 세팅 시작
                 trimAccNo = sDrAccNo.trim();
                 startIdx = trimAccNo.length() - 4 < 1 ? 0 : trimAccNo.length()-4;    
                 //substring을 위한 세팅 종료
                 
                 sHashEntry = String.valueOf((Integer.parseInt(sLimit) + Integer.parseInt(trimAccNo.substring(startIdx, trimAccNo.length()))));
                 sHashEntry = CommonUtils.getFillString(sHashEntry, "0" , 15 , "RIGHT");

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
        		 			CommonUtils.getFillString("PBB", " " , 10 , "") +
        		 			CommonUtils.getFillString(String.valueOf((claimDetailList.size() + 2)), "0" , 10 , "RIGHT") +
        		 			CommonUtils.getFillString(String.valueOf(iTotalAmt), "0" , 20 , "RIGHT") +
        		 			CommonUtils.getFillString(String.valueOf(iHashTot), "0" , 15 , "RIGHT") +        		 			
        		 			CommonUtils.getFillString("", " " , 129 , "");
        
        
         out.write(sTextBtn);
		 out.newLine();
		 out.flush();
         out.close();

		 // 메일 보내기는 나중에
         //Stringstring EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + batchCtrl.CtrlBatDate.Value.ToShortDateString();
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
 		 
 		String count = CommonUtils.getFillString(String.valueOf((claimDetailList.size() + 2)), " " , 6 , "RIGHT");
 		String iTotalAmtStr = CommonUtils.getFillString(CommonUtils.getNumberFormat( String.valueOf(iTotalAmt / 100), "#,##0.00")," " ,13, "RIGHT");
 		 
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
 		
 		// 메일 보내기는 나중에
        //Stringstring EmailTitle = "CIMB Auto Debit Claim File - Batch Date" + batchCtrl.CtrlBatDate.Value.ToShortDateString();
        //SendEmailAutoDebitDeduction(EmailTitle, Location);
	 }
	 
	 
	
}
