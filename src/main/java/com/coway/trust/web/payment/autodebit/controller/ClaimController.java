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
				System.out.println("##################### CREATE BANK FILE HLBB");
			}
			
			//MBB
			if("21".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				System.out.println("##################### CREATE BANK FILE MBB");
			}
			
			//PBB
			if("6".equals(String.valueOf(claimMap.get("ctrlBankId")))){				
				System.out.println("##################### CREATE BANK FILE PBB");
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
		 String sFile = "ALB" + CommonUtils.changeFormat(inputDate, "YYYY-MM-DD" , "yyyyMMdd") + "B01.txt";
		 
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
                 stextDetails = "D|101|" + sDrAccNo + "|" + sLimit + "|" + CommonUtils.changeFormat(sBillDate, "YYYY-MM-DD" , "ddMMyyyy") + "| |" + sDocno + "|";
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
         String hCollectionDate = CommonUtils.changeFormat(inputDate, "YYYY-MM-DD", "ddMMyyyy");
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
		 String sFile = "CIMB" + CommonUtils.changeFormat(inputDate, "YYYY-MM-DD" , "yyyyMMdd") + "B01.dat";
		 
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
		 String sbatchNo = CommonUtils.changeFormat(inputDate, "yyyyMMdd" , "ddMMyy") + "01";		 
		 String sSecCode = CommonUtils.getFillString(String.valueOf((Integer.parseInt(sbatchNo) + 1208083646)), " ", 10, "RIGHT");
		 String sText = "01" + CommonUtils.changeFormat(inputDate, "yyyyMMdd" , "ddMMyy") + "01" + "2120" + CommonUtils.getFillString("WOONGJIN COWAY", " ", 40, "") +
        		 CommonUtils.changeFormat(inputDate, "yyyyMMdd" , "ddMMyy") + sSecCode + CommonUtils.getFillString("", " ",128, "");
        		 
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
	
}
