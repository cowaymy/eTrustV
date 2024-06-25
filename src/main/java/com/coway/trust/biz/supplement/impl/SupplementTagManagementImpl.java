package com.coway.trust.biz.supplement.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.supplement.SupplementTagManagementService;
import com.coway.trust.biz.supplement.impl.SupplementTagManagementMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplementTagManagementService")
public class SupplementTagManagementImpl
  extends EgovAbstractServiceImpl
  implements SupplementTagManagementService {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementTagManagementImpl.class );

  @Resource(name = "supplementTagManagementMapper")
  private SupplementTagManagementMapper supplementTagManagementMapper;

  @Override
  public List<EgovMap> selectTagStus() {
    return supplementTagManagementMapper.selectTagStus();
  }

  @Override
  public List<EgovMap> selectTagManagementList( Map<String, Object> params )
    throws Exception {
    return supplementTagManagementMapper.selectTagManagementList( params );
  }

  @Override
  public List<EgovMap> getMainTopicList() {
    return supplementTagManagementMapper.getMainTopicList();
  }

  @Override
  public List<EgovMap> getInchgDeptList() {
    return supplementTagManagementMapper.getInchgDeptList();
  }

  @Override
  public List<EgovMap> getSubTopicList( Map<String, Object> params ) {
    return supplementTagManagementMapper.getSubTopicList( params );
  }

  @Override
  public List<EgovMap> getSubDeptList( Map<String, Object> params ) {
    return supplementTagManagementMapper.getSubDeptList( params );
  }

  @Override
  public EgovMap selectOrderBasicInfo( Map<String, Object> params )
    throws Exception {
    return supplementTagManagementMapper.selectOrderBasicInfo( params );
  }

  @Override
  public EgovMap searchOrderBasicInfo( Map<String, Object> params ) {
    return supplementTagManagementMapper.searchOrderBasicInfo( params );
  }

  @Override
  public EgovMap selectViewBasicInfo( Map<String, Object> params ) {
    return supplementTagManagementMapper.selectViewBasicInfo( params );
  }

  @Autowired
  private FileService fileService;

  @Autowired
  private FileMapper fileMapper;



  /* THIS FUNCTION TO GENERATE TAG NUMBER */
  private String getTagTokenNo() {
    /* PREFIX : "S" + YYYYMMDD + '6 DIGIT RUNNING NUMBER (DOC: 200)*/
    // STEP 1 : GET TODAY DATE IN YYYYMMDD
    LocalDate today = LocalDate.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
    String formattedDate = today.format(formatter);

    // GET RUNNING SEQUENCE NUMBER
    String seqNo = supplementTagManagementMapper.getDocNo(200);

    // COMBINE TOGETHER
    return "S" + formattedDate + seqNo;
  }

  @Override
  public List<EgovMap> getResponseLst( Map<String, Object> params ) throws Exception {
    return supplementTagManagementMapper.getResponseLst( params );
  }

  @Override
  public void insertTagSubmissionAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs) {
    // TODO Auto-generated method stub
    int fileGroupKey = fileMapper.selectFileGroupKey();
    AtomicInteger i = new AtomicInteger(0); // get seq key.

    list.forEach(r -> {this.insertFile(fileGroupKey, r, type, params, seqs.get(i.getAndIncrement()));});
    params.put("fileGroupKey", fileGroupKey);
  }

  public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params,String seq) {
      LOGGER.debug("insertFile :: Start");

      int atchFlId = supplementTagManagementMapper.selectNextFileId();

      FileGroupVO fileGroupVO = new FileGroupVO();

      Map<String, Object> flInfo = new HashMap<String, Object>();
      flInfo.put("atchFileId", atchFlId);
      flInfo.put("atchFileName", flVO.getAtchFileName());
      flInfo.put("fileSubPath", flVO.getFileSubPath());
      flInfo.put("physiclFileName", flVO.getPhysiclFileName());
      flInfo.put("fileExtsn", flVO.getFileExtsn());
      flInfo.put("fileSize", flVO.getFileSize());
      flInfo.put("filePassword", flVO.getFilePassword());
      flInfo.put("fileUnqKey", params.get("claimUn"));
      flInfo.put("fileKeySeq", seq);

      supplementTagManagementMapper.insertFileDetail(flInfo);

      fileGroupVO.setAtchFileGrpId(fileGroupKey);
      fileGroupVO.setAtchFileId(atchFlId);
      fileGroupVO.setChenalType(flType.getCode());
      fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
      fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));

      fileMapper.insertFileGroup(fileGroupVO);

      LOGGER.debug("insertFile :: End");
  }

  @Override
  public Map<String, Object> supplementTagSubmission(Map<String, Object> params) throws Exception {
    List<Object> supplementItemGrid = (List<Object>) params.get("supplementItmList");
    Map<String, Object> rtnMap = new HashMap<>();

    try {
      // Get the master sequence and set it in params
      int tagSeq = supplementTagManagementMapper.getSeqSUP0006M();


      params.put("salesOrdId", "0");
      params.put("TypeId", "260");

      params.put("seqM", tagSeq);
      params.put("tokenM", getTagTokenNo());

      // Insert the master record
      supplementTagManagementMapper.insertSupplementTagMaster(params);


/*      int ccr06Seq = supplementTagManagementMapper.getSeqCCR0006D();
      params.put("seqCcrId", ccr06Seq);

      int ccr07Seq = supplementTagManagementMapper.getSeqCCR0007D();
      params.put("seqCcrResultId", ccr07Seq);*/


      // Loop through the items and insert each detail record
      //for (int idx = 0; idx < supplementItemGrid.size(); idx++) {
       // Map<String, Object> itemMap = (Map<String, Object>) supplementItemGrid.get(idx);
       // int supplementDetailSeq = supplementTagManagementMapper.getSeqSUP0004D();
       // itemMap.put("seqD", supplementDetailSeq);
       // itemMap.put("seqM", supplementMasterSeq);
       // itemMap.put("crtUsrId", params.get("crtUsrId"));

       // supplementTagManagementMapper.insertSupplementSubmissionDetail(itemMap);
      //}

      // Set the success response
     // rtnMap.put("logError", "000");
     // rtnMap.put("message", params.get("sofNo"));

    } catch (Exception e) {
      // Log the exception (using a logging framework like SLF4J is recommended)
      System.err.println("Error during supplement submission registration: " + e.getMessage());
      e.printStackTrace();

      // Set the error response
      rtnMap.put("logError", "999");
      rtnMap.put("message", e.getMessage());

      // Optionally rethrow the exception if you want it to propagate further
      // throw e;
    }

    return rtnMap;
  }
}
