package com.coway.trust.biz.organization.organization.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.eHPmemberListService;
import com.coway.trust.biz.organization.organization.impl.eHPmemberListMapper;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.eHPmemberListController;


import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("eHPmemberListService")

public class eHPmemberListServiceImpl extends EgovAbstractServiceImpl implements eHPmemberListService{
    private static final Logger logger = LoggerFactory.getLogger(eHPmemberListController.class);

    @Resource(name = "eHPmemberListMapper")
    private eHPmemberListMapper eHPmemberListMapper;

  @Override
  public List<EgovMap> getAttachList(Map<String, Object> params) {
  return eHPmemberListMapper.selectAttachList(params);
  }

  @Override
     public List<EgovMap> selectEHPMemberList(Map<String, Object> params) {
          return eHPmemberListMapper.selectEHPMemberList(params);
      }

     @Override
      public List<EgovMap> selectEHPApplicantList(Map<String, Object> params) {
          return eHPmemberListMapper.selectEHPApplicantList(params);
      }

      public String getRandomNumber(int a){
        Random random = new Random();
        char[] chars = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
        StringBuilder sb = new StringBuilder();

        for(int i=0; i<a; i++){
            int num = random.nextInt(a);
            sb.append(chars[num]);
        }

        return sb.toString();
    }

      public EgovMap getDocNo(String docNoId){
        int tmp = Integer.parseInt(docNoId);
        String docNo = "";
        EgovMap selectDocNo = eHPmemberListMapper.selectDocNo(docNoId);
        logger.debug("selectDocNo : {}",selectDocNo);
        String prefix = "";

        if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

            if(selectDocNo.get("c2") != null){
                prefix = (String) selectDocNo.get("c2");
            }else{
                prefix = "";
            }
            docNo = prefix.trim()+(String) selectDocNo.get("c1");
            //prefix = (selectDocNo.get("c2")).toString();
            logger.debug("prefix : {}",prefix);
            selectDocNo.put("docNo", docNo);
            selectDocNo.put("prefix", prefix);
        }
        return selectDocNo;
    }

      public EgovMap getDocNoNumber(String docNoId){
        int tmp = Integer.parseInt(docNoId);
        String docNo = "";
        EgovMap selectDocNo = eHPmemberListMapper.selectDocNo(docNoId);
        logger.debug("selectDocNo : {}",selectDocNo);

        if(docNoId.equals("130") && Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){
            docNo = (String) selectDocNo.get("c2")+(String) selectDocNo.get("c1");
            logger.debug("docNo : {}",docNo);
            selectDocNo.put("docNo", docNo);
        }
        return selectDocNo;
    }

    public void updateDocNoNumber(String docNoId){//코드값에 따라 자리수 다르게
        EgovMap selectDocNoNumber = eHPmemberListMapper.selectDocNo(docNoId);
        logger.debug("selectDocNoNumber : {}",selectDocNoNumber);
        int nextDocNoNumber = Integer.parseInt((String)selectDocNoNumber.get("c1")) + 1;
        String nextDocNo="";
        if(docNoId.equals("145") || docNoId.equals("12")){
            nextDocNo = String.format("%07d", nextDocNoNumber);
        }else{//130일때,120일때,119일때
        nextDocNo = String.format("%08d", nextDocNoNumber);
        }
        selectDocNoNumber.put("nextDocNo", nextDocNo);
        logger.debug("selectDocNoNumber last : {}",selectDocNoNumber);
        eHPmemberListMapper.updateDocNo(selectDocNoNumber);
    }

    public String getNextDocNo(String prefixNo,String docNo){
        String nextDocNo = "";
        int docNoLength=0;
        System.out.println("!!!"+prefixNo);
        if(prefixNo != null && prefixNo != ""){
            System.out.println("들어오면안됨");
            docNoLength = docNo.replace(prefixNo, "").length();
            docNo = docNo.replace(prefixNo, "");
        }else{
            System.out.println("들어와얗ㅁ");
            docNoLength = docNo.length();

            if ( prefixNo.equals("TR")) {
                docNo = docNo.replace(prefixNo, "");

                docNo.substring(2);
                logger.debug(">>>>>>>>>docNo >>>>>>>>>>>>>>>>>>>>>>>>" +docNo );
                logger.debug(">>>>>>>>>docNo >>>>>>>>>>>>>>>>>>>>>>>>" +docNo.substring(2) );
            }
        }

        logger.debug(">>>>>>>>>docNo >>>>>>>>>>>>>>>>>>>>>>>>" +docNo );

        int nextNo = Integer.parseInt(docNo) + 1;
        nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
        logger.debug("nextDocNo : {}",nextDocNo);
        return nextDocNo;
    }


      public String saveEHPMember(Map<String, Object> params, SessionVO sessionVO) {

          String memCode = "";

          logger.debug("saveEHPMember - params : {}", params);
          if (Integer.parseInt((String) params.get("eHPmemberType")) == 2803) {
              return insertEHPApplicant(params, sessionVO);
          }

          return memCode;
      }

      public String insertEHPApplicant(Map<String, Object> params, SessionVO sessionVO ) {

          logger.debug("insertEHPApplicant - params : {}", params);

          String appId = "";

          Map<String, Object> MemApp = new HashMap<String, Object>();
          Map<String, Object> codeMap1 = new HashMap<String, Object>();

          MemApp.put("applicationID", 0);
          MemApp.put("applicantCode", "");
          MemApp.put("applicantType", Integer.parseInt((String) params.get("eHPmemberType")));
          MemApp.put("applicantName", params.get("eHPmemberNm").toString());
          MemApp.put("applicantFullName", params.get("eHPmemberNm").toString());
          MemApp.put("applicantIdentification", getRandomNumber(5));
          MemApp.put("applicantNRIC", params.get("eHPnric").toString());
          MemApp.put("applicantDOB", params.get("eHPBirth").toString());
          MemApp.put("applicantGender", params.get("eHPgender"));
          MemApp.put("applicantRace", Integer.parseInt((String) params.get("eHPcmbRace")));
          MemApp.put("applicantMarital", Integer.parseInt((String) params.get("eHPmarrital")));
          MemApp.put("applicantNationality", Integer.parseInt((String) params.get("eHPnational")));

          MemApp.put("applicantTelOffice", params.get("eHPofficeNo").toString().trim() != null ? params.get("eHPofficeNo").toString().trim() : "");
          MemApp.put("applicantTelHouse", params.get("eHPresidenceNo").toString().trim() != null ? params.get("eHPresidenceNo").toString().trim() : "");
          MemApp.put("applicantTelMobile", params.get("eHPmobileNo").toString().trim() != null ? params.get("eHPmobileNo").toString().trim() : "");
          MemApp.put("applicantEmail", params.get("eHPemail").toString().trim() != null ? params.get("eHPemail").toString().trim() : "");

          MemApp.put("applicantSpouseCode", params.get("eHPspouseCode").toString().trim() != null ? params.get("eHPspouseCode").toString().trim() : "");
          MemApp.put("applicantSpouseName", params.get("eHPspouseName").toString().trim() != null ? params.get("eHPspouseName").toString().trim() : "");
          MemApp.put("applicantSpouseNRIC", params.get("eHPspouseNric").toString().trim() != null ? params.get("eHPspouseNric").toString().trim() : "");
          MemApp.put("applicantSpouseOccupation", params.get("eHPspouseOcc").toString().trim() != null ? params.get("eHPspouseOcc").toString().trim() : "");
          MemApp.put("applicantSpouseTelContact", params.get("eHPspouseContat").toString().trim() != null ? params.get("eHPspouseContat").toString().trim() : "");
          MemApp.put("applicantSpouseDOB", params.get("eHPspouseDob").toString().trim() != null ? params.get("eHPspouseDob").toString().trim() : "01/01/1900");
          MemApp.put("applicantEduLevel", params.get("eHPeducationLvl") != null && params.get("eHPeducationLvl") != "" ? Integer.parseInt(params.get("eHPeducationLvl").toString().trim()) : 0);
          MemApp.put("applicantLanguage", params.get("eHPlanguage") != "" && params.get("eHPlanguage") != null ? Integer.parseInt(params.get("eHPlanguage").toString().trim()) : 0);
          MemApp.put("applicantBankID", Integer.parseInt(params.get("eHPissuedBank").toString()));
          MemApp.put("applicantBankAccNo", params.get("eHPbankAccNo").toString().trim());
          MemApp.put("eHPincomeTaxNo", params.get("eHPincomeTaxNo").toString().trim());
          MemApp.put("applicantSponsorCode", params.get("eHPsponsorCd").toString().trim() != null ? params.get("eHPsponsorCd").toString().trim() : "");
          MemApp.put("applicantTransport", 0);
          MemApp.put("remark", "eHP registration");
          MemApp.put("statusId", 44);
          MemApp.put("created", new Date());
          // MemApp.put("creator",52366);
          MemApp.put("creator", sessionVO.getUserId());
          MemApp.put("updated", new Date());
          // MemApp.put("updator",52366);
          MemApp.put("updator", sessionVO.getUserId());
          MemApp.put("confirmation", false);
          MemApp.put("confirmDate", "01/01/1900");
          MemApp.put("deptCode", params.get("eHPdeptCd").toString());
          // addr 주소 가져오기
          // MemApp.put("areaId",params.get("searchSt1").toString());
          MemApp.put("areaId", params.get("eHPareaId").toString());
          MemApp.put("streetDtl", params.get("eHPstreetDtl") != null ? params.get("eHPstreetDtl").toString() : "");
          MemApp.put("addrDtl", params.get("eHPaddrDtl") != null ? params.get("eHPaddrDtl").toString() : "");

          MemApp.put("searchdepartment", "");
          MemApp.put("searchSubDept", "");

          MemApp.put("meetingPoint", params.get("eHPmeetingPoint").toString());
          MemApp.put("collectionBrnch", params.get("eHPcollectionBrnch").toString());

          MemApp.put("coursId", params.get("eHPorientation") != null ? params.get("eHPorientation").toString() : "");

          MemApp.put("atchFileGrpId", params.get("atchFileGrpId").toString());
          MemApp.put("registrationOption", params.get("eHPregOpt").toString());

          if (Integer.parseInt((String) params.get("eHPmemberType")) == 2803) {
              logger.debug("MemApp : {}", MemApp);
              EgovMap appNo = getDocNo("145");
              MemApp.put("applicantCode", appNo.get("docNo"));
              logger.debug("appNo : {}", appNo);
              updateDocNoNumber("145");
          }

          // HP applicant
          eHPmemberListMapper.insertEHPMemApp(MemApp); // INSERT ORG0003D
          codeMap1.put("code", "memApp");
          appId = eHPmemberListMapper.selectMemberId(codeMap1);

          return MemApp.get("applicantCode").toString();
      }

      @Override
      public void eHPMemberUpdate(Map<String, Object> params) throws Exception{
          eHPmemberListMapper.eHPMemberUpdate(params);
      }

      @Override
      public EgovMap selectEHPmemberListView(Map<String, Object> params) {
          // TODO Auto-generated method stub
          return eHPmemberListMapper.selectEHPmemberListView(params);
      }

      @Override
      public List<EgovMap> selectEHPmemberView(Map<String, Object> params) {
          // TODO Auto-generated method stub
          return eHPmemberListMapper.selectEHPmemberView(params);
      }

      @Override
      public List<EgovMap> selectCollectBranch() {
          return eHPmemberListMapper.selectCollectBranch();
      }


      public void eHPmemberStatusInsert(Map<String, Object> params) {
       eHPmemberListMapper.eHPmemberStatusInsert(params);

    }

      public void eHPmemberStatusUpdate(Map<String, Object> params) {
        eHPmemberListMapper.eHPmemberStatusUpdate(params);

     }

      public void eHPApplicantStatusUpdate(Map<String, Object> params) {
        eHPmemberListMapper.eHPApplicantStatusUpdate(params);

     }

      public List<EgovMap> eHPselectStatus() {
        return eHPmemberListMapper.eHPselectStatus();
    }

      @Override
      public EgovMap selectEHPMemberListView(Map<String, Object> params) {
          return eHPmemberListMapper.getEHPMemberListView(params);
      }

      @Override
      public List<EgovMap> getDetailCommonCodeList(Map<String, Object> params) {
          return eHPmemberListMapper.getDetailCommonCodeList(params);
      }

    @Override
    public List<EgovMap> selectHPOrientation(Map<String, Object> params) {
        return eHPmemberListMapper.selectHPOrientation(params);
    }

  //@AMEER INCOME TAX 20210928
  	/*@Override
      public EgovMap checkIncomeTax(Map<String, Object> params) {
          return eHPmemberListMapper.checkIncomeTax(params);
      }*/

    @Override
    public List<EgovMap> selectHpApplByEmail(Map<String, Object> params) {
        return eHPmemberListMapper.selectHpApplByEmail(params);
    }

    @Override
	public List<EgovMap> selecteHPFailRemark(Map<String, Object> params) {
		return eHPmemberListMapper.selecteHPFailRemark(params);
	}

    public List<EgovMap> getMemberExistByNRIC(Map<String, Object> params){
    	return eHPmemberListMapper.getMemberExistByNRIC(params);
    }

}
