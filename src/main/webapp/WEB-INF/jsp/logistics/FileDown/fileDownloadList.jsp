<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var userCode;

var userSession = ${SESSION_INFO.userId};
                    
 var rescolumnLayout=[
                      {dataField:"fileUploadId"         ,headerText:"fileUploadId"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"fileTypeId"         ,headerText:"fileTypeId"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"codeName"       ,headerText:"Type"                      ,width:200    ,height:30 },
                      {dataField:"fileTypeLbl"      ,headerText:"Label"      ,width:400    ,height:30                },
                      {dataField:"fileName"        ,headerText:"Filename"               ,width:600    ,height:30  },
                      {dataField:"isCody"      ,headerText:"Cody"                      ,width:60    ,height:30                
                   	   , renderer : 
                         {
                             type : "CheckBoxEditRenderer",
                             showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                             //editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                             checkValue : 1, // true, false 인 경우가 기본
                             unCheckValue :0
                         }  
                      },
                      {dataField:"isHp"     ,headerText:"HP" ,width:60    ,height:30 
                    	  , renderer : 
                          {
                              type : "CheckBoxEditRenderer",
                              showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                              //editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                              checkValue :1, // true, false 인 경우가 기본
                              unCheckValue :0
                          }  
                      },
                      {dataField:"isStaff"        ,headerText:"Staff"            ,width:60    ,height:30 
                    	  , renderer : 
                          {
                              type : "CheckBoxEditRenderer",
                              showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                              //editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                              checkValue :1, // true, false 인 경우가 기본
                              unCheckValue : 0
                          }                
                      },
                      {dataField:"crtUserId"        ,headerText:"crtUserId"               ,width:110    ,height:30 , visible:false },
                      {dataField:"c1"        ,headerText:"Creator"               ,width:110    ,height:30 },
                      {dataField:"crtDt"       ,headerText:"Create Date"               ,width:110    ,height:30},
                      {dataField:"fileUrl"        ,headerText:"FILE_URL"         ,width:120    ,height:30 , visible:false},
                      {
                          dataField : "",
                          headerText : "",
                          renderer : {
                              type : "ButtonRenderer",
                              labelText : "Download",
                              onclick : function(rowIndex, columnIndex, value, item) {
                                // removeRow(rowIndex, gridNm,chkNum);
                                fileDown(rowIndex);
                              }
                          }
                      , editable : false
                      },
/*                       {dataField:"subpath"         ,headerText:"subpath"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"filename"         ,headerText:"filename"                      ,width:120    ,height:30 , visible:false} */
                      {dataField:"subpath"         ,headerText:"subpath"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"filename"         ,headerText:"filename"                      ,width:120    ,height:30 , visible:false}
                      ];                     
                                    
//var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {
        showStateColumn : false , 
        editable : false, 
        pageRowCount : 30, 
        usePaging : true, 
        useGroupingPanel : false,
        };
        
var subgridpros = {
        // 페이지 설정
        usePaging : true,                
        pageRowCount : 20,                
        editable : false,                
        noDataMessage :  "<spring:message code='sys.info.grid.noDataMessage' />",
        enableSorting : true,
        //selectionMode : "multipleRows",
        //selectionMode : "multipleCells",
        useGroupingPanel : true,
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        // 전체 체크박스 표시 설정
        showRowAllCheckBox : true,
        //softRemoveRowMode:false
        };
var resop = {
        rowIdField : "rnum",            
        editable : true,
        fixedColumnCount : 6,
        groupingFields : ["reqstno"],
        displayTreeOpen : true,
        showRowCheckColumn : true ,
        enableCellMerge : true,
        showStateColumn : false,
        showRowAllCheckBox : true,
        showBranchOnGrouping : false
        };


        
var paramdata;

$(document).ready(function(){
	

doGetCombo('/common/selectCodeList.do', '70', '','searchFileType', 'M' , 'f_multiCombo'); //File Type 리스트 조회
//$("#fileSpace").val("You required to upload your file after save file space.");
//$("#uploadFileText").val("Only allow .zip file || Max file size : 5MB || File will be overwrite if you re-upload");   


    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, gridoptions);    
    
    
    
    
});


//btn clickevent
$(function(){
    $('#search').click(function() {
        SearchListAjax();
    });
    $('#clear').click(function() {
    	$("#searchForm")[0].reset();
    	doGetCombo('/common/selectCodeList.do', '70', '','searchFileType', 'M' , 'f_multiCombo'); //File Type 리스트 조회
    });
    
    $('#newUpFile').click(function() {
    	
    	$("#pop_title").text("Save New File Space");
    	$("#ReceivePopUp_wrap").show();
    	$("#fileSpace_tr").show();
    	$("#newbtn").show();
    	$("#editbtn").hide();
    	$("#delbtn").hide();
    	doGetCombo('/common/selectCodeList.do', '70', '','insType', 'S' , ''); //Save Type 리스트 조회
    	//getComboRelayss('' ,'' , '', '1');
    	 $("#insTypeLabel1").attr("checked", false);
    	 $("#insTypeLabel2").attr("checked", false);
    	 $("input[name='insTypeLabel']").prop('disabled', true);
    	 
    	 $("#insNewLabel").val('');
    	 doGetComboSelBox('/logistics/file/selectLabelList.do', '' , '' , '','insExistingLabel', 'S', '');
    	 $("#ExistingLabel").show();
    	 $("#NewLabel").hide();
    	 $("#thLabel").text("Existing Label"); 
    	 $("#insFileNm").val('');
    	 $("#insStaff").prop("checked", true);
    	 $("#insCody").prop("checked", true);
    	 $("#insHP").prop("checked", true);
    });
    $('#editFile').click(function() {
    	 var selectedItem = AUIGrid.getSelectedIndex(listGrid);
         if(selectedItem[0] < 0 ){
             Common.alert('Please select Row.');
             return false;
         }else{
          if(userSession !=AUIGrid.getCellValue(listGrid,  selectedItem[0], "crtUserId")){
                Common.alert("You are not the owner of file space. Edit file space is disallowed. ");
                  return false;
           }
	    	$("#pop_title").text("Edit File Space");
	    	$("#ReceivePopUp_wrap").show();
	    	$("#fileSpace_tr").hide();
	    	$("#newbtn").hide();
	    	$("#editbtn").show();
	    	$("#delbtn").show();
	    	fn_dataSet();
         }
    });
    $('#reUpFile').click(function() {
    	$("input[id=fileSelector]").val('');
    	$(".auto_file input[type=text]").val('');
    	$(".auto_file input[type=text]").text('');
    	 var selectedItem = AUIGrid.getSelectedIndex(listGrid);
         if(selectedItem[0] < 0 ){
             Common.alert('Please select Row.');
             return false;
         }else{
        	  if(userSession !=AUIGrid.getCellValue(listGrid,  selectedItem[0], "crtUserId")){
        	         Common.alert("You are not the owner of file space. Re-upload is disallowed.");
        	           return false;
        	    }
	    	$("#UploadFilePopUp_wrap").show();
	    	$("#newUp").hide();
	    	$("#reUp").show();
         }
    });
    
    $("input:radio[name=insTypeLabel]").click(function(){
        var radioValue =    $("input:radio[name=insTypeLabel]:checked").val();
       
           if(radioValue == "E" ){
        	   var val = $("#insType").val();
	       	   $("#insNewLabel").val(""); 
        	   $("#insExistingLabel").attr("disabled", false);
        	   $("#ExistingLabel").show(); 
        	   $("#NewLabel").hide(); 
        	   $("#thLabel").text("Existing Label"); 
        	   doGetComboSelBox('/logistics/file/selectLabelList.do', '' , val , '','insExistingLabel', 'S', ''); //Label 리스트 조회                
            }else{
        	    $("#insExistingLabel").val(""); 
            	$("#NewLabel").show();
            	$("#ExistingLabel").hide(); 
        	   $("#thLabel").text("New Label"); 
            }       
    }) 
    
    $("input[id=fileSelector]").change(function(){
        // 필드 채워지면
        if($(this).val() != ""){
            // 확장자 체크
                var ext = $(this).val().split(".").pop().toLowerCase();
                if($.inArray(ext, ["zip"]) == -1){
                	Common.alert("Only allows .zip file.");
                    $(this).val("");
                    return false;
                }
                
                // 용량 체크
                var fileSize = this.files[0].size;
                var maxSize = 1024 * 1024*5;
                if(fileSize > maxSize){
                	Common.alert("Only allows Max file size : 5MB");
                    $(this).val("");
                    return false;
                }
        }
    });

   
   
});

// function SearchSessionAjax() {
//     var url = "/logistics/totalstock/SearchSessionInfo.do";
//     Common.ajaxSync("GET" , url , '' , function(result){
//         userCode=result.UserCode;

//     });
// }


function SearchListAjax() {
    var url = "/logistics/file/fileDownloadList.do";
    var param = $('#searchForm').serialize();
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}


function fn_insertFileSpace(flag){
	if(flag =="S"){
	  //div="FS"  
	 fileSpaceSaveAjax();
	}else{
		   if(""==$("input[id=fileSelector]").val()){
			   Common.alert("Please attach a file.");
			   return false;
		   }
		if(flag =="U"){
		 fileSaveAjax();
		}else if(flag =="R"){
	      fn_reUpFile();
		}
			
	} 
	
   
}


function fileSpaceSaveAjax() {
    var url;
    var param;
       param= $("#FileSpaceForm").serializeJSON();
       url="/logistics/file/insertFileSpace.do";    
   Common.ajax("POST",url,param,function(result){
       if(result.cnt == 0){
	        $("#upId").val(result.re);
	        $("#UploadFilePopUp_wrap").show();
	        $("input[id=fileSelector]").val('');
	        $(".auto_file input[type=text]").val('');
	        $(".auto_file input[type=text]").text('');
	        $("#newUp").show();
	        $("#reUp").hide();
    	   
       }else{
    	   Common.alert("* Same file space is exist.");
       }
   });
} 
function fileSaveAjax() {
    var url;
    var formData = new FormData();
        url="/logistics/file/insertFile.do";    
         formData.append("excelFile", $("input[name=zipUpload]")[0].files[0]);
         formData.append("upId", $("#upId").val());
   Common.ajaxFile(url,formData,function(result){
    	Common.alert("File successfully uploaded.");
	   $("#UploadFilePopUp_wrap").hide();
	   $("#ReceivePopUp_wrap").hide();
	   SearchListAjax();
   });
} 



function f_multiCombo() {
    $(function() {
        $('#searchFileType').change(function() {
        }).multipleSelect({
            selectAll : true
        });  /* .multipleSelect("checkAll"); */        
    });
}


function getComboRelayss(obj, value, tag, selvalue) {
    var robj = '#' + obj;
    $(robj).attr("disabled", false);
    $("input[name='insTypeLabel']").prop('checked', false);
    $("#insTypeLabel1").attr("disabled", false); 
    $("#insTypeLabel2").attr("disabled", false); 
    $("#insNewLabel").val(""); 
    $("#insExistingLabel").val(""); 
    $("#ExistingLabel").show(); 
    $("#NewLabel").hide(); 
    $("#thLabel").text("Existing Label"); 
    doGetComboSelBox('/logistics/file/selectLabelList.do', tag , value , selvalue,obj, 'S', ''); //Label 리스트 조회                
}

function doGetComboSelBox(url, groupCd, codevalue, selCode, obj, type, callbackFn) {
    $.ajax({
        type : "GET",
        url : url,
        data : {
            groupCode : codevalue
        },
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombos(rData, selCode, obj, type, callbackFn);
        },
        error : function(jqXHR, textStatus, errorThrown) {
            alert("Draw ComboBox['" + obj
                    + "'] is failed. \n\n Please try again.");
        },
        complete : function() {
        }
    });
};

function doDefCombos(data, selCode, obj, type, callbackFn) {
    var targetObj = document.getElementById(obj);
    var custom = "";
    for (var i = targetObj.length - 1; i >= 0; i--) {
        targetObj.remove(i);
    }
    obj = '#' + obj;
    if (type && type != "M") {
        custom = (type == "S") ? eTrusttext.option.choose
                : ((type == "A") ? eTrusttext.option.all : "");
        $("<option />", {
            value : "",
            text : custom
        }).appendTo(obj);
    } else {
        $(obj).attr("multiple", "multiple");
    }

    $.each(data, function(index, value) {
        //CODEID , CODE , CODENAME ,,description
        if (selCode == data[index].codeName) {
            $('<option />', {
                value : data[index].codeName,
                text : data[index].codeName
            }).appendTo(obj).attr("selected", "true");
        } else {
            $('<option />', {
                value : data[index].codeName,
                text : data[index].codeName
            }).appendTo(obj);
        }
    });

    if (callbackFn) {
        var strCallback = callbackFn + "()";
        eval(strCallback);
    }
};

function fileDown(rowIndex){
      var subPath = AUIGrid.getCellValue(listGrid,  rowIndex, "subpath");
      var fileName = AUIGrid.getCellValue(listGrid,  rowIndex, "filename");
      var orignlFileNm = AUIGrid.getCellValue(listGrid,  rowIndex, "fileName")+".zip";
   if(""==subPath || null==subPath ||""==fileName || null==fileName ){
	   Common.alert("File is not exist.");
	   return false;
   }
    window.open("<c:url value='/file/fileDown.do?subPath=" + subPath
            + "&fileName=" + fileName + "&orignlFileNm=" + orignlFileNm
            + "'/>");
}

function fn_modifyileSpace(str){
	var selectedItem = AUIGrid.getSelectedIndex(listGrid);
	var fileUploadId = AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileUploadId");
	var url;
    var param;
    var msg="";
	if(str=="M"){
       url="/logistics/file/insertFileSpace.do";  
       msg="File space has successfully updated.";
	}else{
       url="/logistics/file/deleteFileSpace.do";    
       msg="File space has been deleted.";
	}
       param= $("#FileSpaceForm").serializeJSON();
       $.extend(param,{ fileUploadId:fileUploadId });
   Common.ajax("POST",url,param,function(result){
	   if(str=="M" & result.cnt>0){
		   msg="* Same file space is exist.";
	   }
        Common.alert(msg);
        $("#ReceivePopUp_wrap").hide();         
        SearchListAjax();

   });
}

function fn_dataSet(){
	   var selectedItem = AUIGrid.getSelectedIndex(listGrid);
	  doGetCombo('/common/selectCodeList.do', '70',AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileTypeId"),'insType', 'S' , '');
        $("#insTypeLabel1").prop("disabled", false);
        $("#insTypeLabel2").prop("disabled", false);
        $("#insTypeLabel1").prop("checked", true);
	    $("#insNewLabel").val(""); 
	    $("#insExistingLabel").prop("disabled", false);
	    $("#ExistingLabel").show(); 
	    $("#NewLabel").hide(); 
	    $("#thLabel").text("Existing Label"); 
	    doGetComboSelBox('/logistics/file/selectLabelList.do', '' ,AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileTypeId") ,AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileTypeLbl"),'insExistingLabel', 'S', '');
	    $("#insFileNm").val(AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileName")); 
	    
	    if(1==AUIGrid.getCellValue(listGrid,  selectedItem[0], "isStaff")){
	        $("#insStaff").prop("checked", true);
	    }else{
	        $("#insStaff").prop("checked", false);
	    }
	    if(1==AUIGrid.getCellValue(listGrid,  selectedItem[0], "isCody")){
	        $("#insCody").prop("checked", true);
	    }else{
	        $("#insCody").prop("checked", false);
	    }
	    if(1==AUIGrid.getCellValue(listGrid,  selectedItem[0], "isHp")){
	        $("#insHP").prop("checked", true);
	    }else{
	        $("#insHP").prop("checked", false);
	    }
}

function fn_reUpFile(){
	var selectedItem = AUIGrid.getSelectedIndex(listGrid);
    var url;
    var formData = new FormData();
        url="/logistics/file/insertFile.do";    
         formData.append("excelFile", $("input[name=zipUpload]")[0].files[0]);
         formData.append("upId",AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileUploadId"));
         formData.append("insType",AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileTypeId"));
         formData.append("insNewLabel",AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileTypeLbl"));
         formData.append("insFileNm",AUIGrid.getCellValue(listGrid,  selectedItem[0], "fileName"));
   Common.ajaxFile(url,formData,function(result){
       $("#UploadFilePopUp_wrap").hide();
       SearchListAjax();
   });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>File Download List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-File Download List</h2>
</aside><!-- title_line end -->



<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span><spring:message code='sys.btn.search' /></a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span><spring:message code='sys.btn.clear' /></a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" name="rStcode" id="rStcode" />    
        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                <th scope="row">File Type</th>
                   <td >
                      <select class="w100p" id="searchFileType" name="searchFileType"><option value=''>Choose One</option></select>
                    </td> 
                    <th scope="row">File Type Label</th>
                    <td>
                        <input type="text" title="" placeholder=""  class="w100p" id="searchTypeLabel" name="searchTypeLabel"/>
                    </td> 
                    <th scope="row">Filename</th>
                    <td>
                        <input type="text" title="" placeholder=""  class="w100p" id="searchFilename" name="searchFilename"/>
                    </td>
                </tr>
                         
            </tbody>
        </table><!-- table end -->
     <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
		<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
		<dl class="link_list">
		    <dt>Link</dt>
		    <dd>
 		    <ul class="btns"> 
 		        <li><p class="link_btn"><a id="editFile">Edit File Space</a></p></li> 
  		        <li><p class="link_btn"><a id="reUpFile">Re-Upload File</a></p></li> 
  		    </ul> 
		    <ul class="btns">
		        <li><p class="link_btn type2"><a id="newUpFile">Upload New File</a></p></li>
		    </ul>
		    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
		    </dd>
		</dl>
		</aside><!-- link_btns_wrap end -->
		        
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
       
    </section><!-- search_result end -->
    
    
    
<div id="ReceivePopUp_wrap" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="pop_title">Save New File Space</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="FileSpaceForm" name="FileSpaceForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td colspan="2" >
    <select class="w100p" id="insType" name="insType" onchange="getComboRelayss('' , this.value , '', '1')" ><option value=''>Choose One</option></select>
    </td>
    <th scope="row"></th>
    <td colspan="2" ></td>
</tr>
<tr>
    <th scope="row">Type Label</th>
    <td colspan="2" >
    <label><input type="radio" id="insTypeLabel1" name="insTypeLabel" value="E"  disabled="disabled"  /><span>Existing Label</span></label>
    <label><input type="radio" id="insTypeLabel2" name="insTypeLabel" value="N"  disabled="disabled" /><span>New Label</span></label>
    </td>
    <th scope="row" id="thLabel">Existing Label</th>
    <td colspan="2" id="NewLabel" style="display: none;"><input type="text" title="" placeholder=""  class="w100p" id="insNewLabel" name="insNewLabel"/></td>
    <td colspan="2" id="ExistingLabel"  ><select class="w100p" id="insExistingLabel" name="insExistingLabel" disabled="disabled"><option value=''>Choose One</option></select></td>
</tr>
<tr>
    <th scope="row">File Name</th>
    <td colspan="2" >
    <input type="text" title="" placeholder=""  class="w100p" id="insFileNm" name="insFileNm"/>
    </td>
    <th scope="row">Allow Member</th>
    <td colspan="2" >
        <label><input type="checkbox"  id="insStaff" name="insStaff"  checked="checked" /><span>Staff</span></label>
        <label><input type="checkbox"  id="insCody" name="insCody"   checked="checked" /><span>Cody</span></label>
        <label><input type="checkbox"  id="insHP" name="insHP"   checked="checked" /><span>HP</span></label>  
    </td>
</tr>
<tr id="fileSpace_tr">
    <td colspan="6" >
    <input type="text" title="" placeholder="You required to upload your file after save file space."  class="readonly w100p" readonly="readonly"  id="fileSpace" name="fileSpace"/>
    </td>
</tr>


</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertFileSpace('S');" id="newbtn">Save File Space</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_modifyileSpace('M');" id="editbtn">Edit File Space</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_modifyileSpace('D');" id="delbtn">Delete File Space</a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
    
    
<div id="UploadFilePopUp_wrap" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Upload File</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="FileSpaceForm2" name="FileSpaceForm2" enctype="multipart/form-data">
<input type="hidden" id="upId" name="upId"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Select File</th>
    <td colspan="5" >
    <div class="auto_file"><!-- auto_file start -->
            <input type="file" id="fileSelector" name="zipUpload" title="file add" accept=".zip"/>
    </div><!-- auto_file end -->
    </td>
</tr>

<tr>
    <td colspan="6" >
    <input type="text" title="" placeholder="Only allow .zip file || Max file size : 5MB || File will be overwrite if you re-upload"  class="readonly w100p" readonly="readonly"  id="uploadFileText" name="uploadFileText"/>
    </td>
</tr>


</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertFileSpace('U');" id="newUp">Upload File</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertFileSpace('R');"id="reUp">Upload File</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->    

</section>

