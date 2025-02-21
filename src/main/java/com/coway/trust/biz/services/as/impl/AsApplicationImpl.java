package com.coway.trust.biz.services.as.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.services.as.AfterServiceApplication;
import com.coway.trust.util.CommonUtils;

@Service("AsApplication")
public class AsApplicationImpl implements AfterServiceApplication {

  private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

  @Value("${app.name}")
  private String appName;

  @Autowired
    private FileService fileService;

  @Autowired
    private FileMapper fileMapper;

    @Resource(name = "ASManagementListMapper")
    private ASManagementListMapper ASManagementListMapper;

  @Override
  public void insertAfterServiceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs) {
    // TODO Auto-generated method stub

    LOGGER.debug("insertAfterServiceAttachBiz - params =====================================>>  " + params.toString());
    LOGGER.debug("insertAfterServiceAttachBiz - list =====================================>>  " + list.toString());

    int fileGroupKey = fileMapper.selectFileGroupKey();
    AtomicInteger i = new AtomicInteger(0); // get seq key.

    list.forEach(r -> {this.insertFile(fileGroupKey, r, type, params, seqs.get(i.getAndIncrement()));});
    params.put("fileGroupKey", fileGroupKey);
  }

  public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params,String seq) {

        LOGGER.info("insertFile - params =====================================>>  " + params.toString());
        LOGGER.info("insertFile - flVO =====================================>>" + flVO.toString());

        int atchFlId = ASManagementListMapper.selectNextFileId();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        Date date1= new Date();
        String strToday = dateFormat.format(date1);

        FileGroupVO fileGroupVO = new FileGroupVO();
        String fileName = "MOBILE_SVC_" + params.get("asNo").toString() + "_" + strToday + "_" + seq + ".jpg";

        Map<String, Object> flInfo = new HashMap<String, Object>();
        flInfo.put("atchFileId", atchFlId);
        flInfo.put("atchFileName", fileName);
        flInfo.put("fileSubPath", flVO.getFileSubPath());
        flInfo.put("physiclFileName", flVO.getPhysiclFileName());
        flInfo.put("fileExtsn", flVO.getFileExtsn());
        flInfo.put("fileSize", flVO.getFileSize());
        flInfo.put("filePassword", flVO.getFilePassword());
  //      flInfo.put("fileUnqKey", params.get("claimUn"));
  //      flInfo.put("fileKeySeq", seq);

        LOGGER.info("insertFile - flInfo =====================================>>  " + flInfo.toString());
        LOGGER.info("[AfterServiceApplicationImpl - insertFile] getAtchFileName :::::::" + flVO.getAtchFileName());
        ASManagementListMapper.insertFileDetail(flInfo);

         //int atchFileGrpId = CommonUtils.intNvl((params.get("atchFileGrpId").toString()));

        /*if(atchFileGrpId != 0){
             fileGroupVO.setAtchFileGrpId(atchFileGrpId);
        }else{
             fileGroupVO.setAtchFileGrpId(fileGroupKey);
        }*/
        fileGroupVO.setAtchFileGrpId(fileGroupKey);
        fileGroupVO.setAtchFileId(atchFlId);
        fileGroupVO.setChenalType(flType.getCode());
        fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
        fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));
        fileMapper.insertFileGroup(fileGroupVO);

        /*Map<String, Object> asRstlInfo = new HashMap<String, Object>();
        if(atchFileGrpId != 0){
          asRstlInfo.put("atchFileGrpId", atchFileGrpId);
        }else{
          asRstlInfo.put("atchFileGrpId", fileGroupKey);
        }*/
        //asRstlInfo.put("salesOrdId", params.get("salesOrdId").toString());
        //asRstlInfo.put("asResultNo", params.get("asResultNo").toString());
        //asRstlInfo.put("updUserId",Integer.parseInt(params.get("userId").toString()));
        //asRstlInfo.put("asResultId",Integer.parseInt(params.get("asResultId").toString()));
        //ASManagementListMapper.updateAfterServiceResultInfo(asRstlInfo);
    }

  @Override
  public void updateAfterServiceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs) {
    // TODO Auto-generated method stub
    String update = (String) params.get("update");
    String remove = (String) params.get("remove");
    String[] updateList = null;
    String[] removeList = null;

    if(!StringUtils.isEmpty(update)) {
      updateList = params.get("update").toString().split(",");
    }
    if(!StringUtils.isEmpty(remove)) {
      removeList = params.get("remove").toString().split(",");
    }
    // serivce 에서 파일정보를 가지고, DB 처리.
    if (list.size() > 0) {
      for(int i = 0; i < list.size(); i++) {
        if(updateList != null && i < updateList.length) {
          String atchFileId = updateList[i];
          fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
        }
        else {
          int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
          this.insertFile(fileGroupId, list.get(i), type,params, seqs.get(i));
        }
      }
    }
    if(removeList != null && removeList.length > 0){
      for(String id : removeList){
        LOGGER.info(id);
        String atchFileId = id;
        fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
      }
    }
  }
}