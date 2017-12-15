<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    var myGenerallGridIDInActive;
    var myDetailGridIDInActive;

    function createAUIGridInactiveGeneral(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ 
                                        
                                        {                        
                                            dataField : "",
                                            headerText : "AS Request Date",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Application Route",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "As Order Number",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Order No",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Customer name",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Product name",
                                            width : 130
                                            //,dataType : "date",
                                            //formatString : "dd/mm/yyyy"   
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Installation Date",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Serial No.",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Status",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Person to bear",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Complete Date",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "RM",
                                            width : 130 
                                        },
                                        {                        
                                            dataField : "",
                                            headerText : "Managing Department",
                                            width : 130 
                                        }    
                                   ];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용       
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,
                
                editable : false,
                
                //showStateColumn : true, 
                
                //displayTreeOpen : true,
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true
        
            };
            myGenerallGridIDInActive = AUIGrid.create("#grid_wrap_general", columnLayout, gridPros);
    }
    
    
    function createAUIGridInactiveDetailLog(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ 
                                        
                                        {                        
                                            dataField : "",
                                            headerText : "Issue Date",
                                            width : 130 
                                        },
                                        {                        
                                        	dataField : "",
                                            headerText : "Leaking/burning",
                                            width : 130 
                                        },
                                        {                        
                                        	dataField : "",
                                            headerText : "Defect Parts",
                                            width : 130 
                                        },
                                        {                        
                                        	dataField : "",
                                            headerText : "Reason",
                                            width : 130 
                                        },
                                        {                        
                                        	dataField : "",
                                            headerText : "Settlement Mothod",
                                            width : 140 
                                        },
                                        {                        
                                        	dataField : "",
                                            headerText : "Attachment",
                                            width : 130
                                            //,dataType : "date",
                                            //formatString : "dd/mm/yyyy"   
                                        },
                                        {                        
                                        	dataField : "",
                                            headerText : "Comensation Item",
                                            width : 140 
                                        }
                                   ];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용       
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,
                
                editable : false,
                
                //showStateColumn : true, 
                
                //displayTreeOpen : true,
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true
        
            };
            myDetailGridIDInActive = AUIGrid.create("#grid_wrap_detailLog", columnLayout, gridPros);
    }
    
      
        
        $(document).ready(function() {
        
            //doDefCombo('', '' ,'searchdepartment', 'M', 'f_deptmultiCombo');
            
           // CommonCombo.make('searchdepartment', '/sales/trBook/getOrganizationCodeList', {memType : $("#searchdepartment").val(), memLvl : 3, parentID : total_item}, '', {type:'M', isCheckAll:false});
            
            doGetCombo('/services/holiday/selectBranchWithNM', 43, '','code', 'S' ,  '');
            
            
            doGetCombo('/services/tagMgmt/selectMainDept.do', '' , '', 'searchdepartment' , 'S', '');
     
    
	       $("#searchdepartment").change(function(){
	         
	         doGetCombo('/services/tagMgmt/selectSubDept.do',  $("#searchdepartment").val(), '','inputSubDept', 'S' ,  ''); 
	         
	     });
	     
	     
	     $("#salesOrdNo").focusout(function(){
             
             Common.ajax("GET", "/services/compensation/selectSalesOrdNoInfo.do",   { salesOrdNo :  $("#salesOrdNo").val() }  , function(result) {
                console.log("selectSalesOrdNoInfo >>> .");
                console.log(  JSON.stringify(result));
                
                 $("#product").val(result[0].stkDesc)
                 $("#Installation").val(result[0].installDt)
                 $("#Serial").val(result[0].serialNo)
              
            }); 
             
         });
            
            setInputFile2();
        });
 
      function setInputFile2(){//인풋파일 세팅하기
                $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
    }
 
    function fn_close() {
        $("#popClose").click();
    }       

    function fn_doSave () {
    
              var  SaveForm ={
                                        "issueDt"               : $("#issueDt").val().replace(/\//g,""),
                                        "asReqsterTypeId"  : $("#asReqsterTypeId").val(),
                                        "asNo"                  : $("#asNo").val(),
                                        "salesOrdNo"          : $("#salesOrdNo").val(),
                                        "custId"                : $("#custId").val(),
                                        "custId"                : $("#custId").val(),
                                        "stusCodeId"          : $("#stusCodeId option:selected").val(),
                                        "compDt"               : $("#compDt").val().replace(/\//g,""),
                                        "compTotAmt"        : $("#compTotAmt").val(),
                                        "mainDept"              : $("#searchdepartment option:selected").val(),
                                        "code"                  : $("#code option:selected").val(),
                                        "asrItmPartId"          : $("#asrItmPart_id").val(),
                                        "asDefectTypeId"    : $("#asDefectTypeId").val(),
                                        "asMalfuncResnId"    : $("#asSlutnResn_id").val(),
                                        "asSlutnResnId"    : $("#asSlutnResn_Id").val(),
                                        "compItem1"         : $("#compItem1").val(),
                                        "compItem2"         : $("#compItem2").val(),
                                        "compItem3"         : $("#compItem3").val(),
                                        "attachFile"            : $("#attachFile").val(),
                                        "compNo"                : $("#compNo").val()
                                        
                                   };
             
             var formData = Common.getFormData("comPensationInfoForm");
             
             var obj = $("#comPensationInfoForm").serializeJSON();
             
             $.each(obj, function(key, value) {
		        formData.append(key, value);
		    });
             
            console.log("저장전 변수값 확인 : " +  JSON.stringify(formData)); 
              
            Common.ajaxFile("/services/compensation/updateCompensation.do",  formData , function(result) {
				console.log("fn_doSave >>> .");
				console.log(  JSON.stringify(result));
				
				if(result.code = "00"){
                    $("#popClose").click();
                    fn_searchASManagement();
                     Common.alert("<b>Compensation successfully edited.</b>",fn_close);
               }else{
                    Common.alert("<b>Failed to edit this Compensation. Please try again later.</b>");
               }     
            }); 
    }

</script>


<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Edit Compensation Log Detail</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="" method="post"  id='comPensationInfoForm' enctype="multipart/form-data"> 
    <input type="hidden" name="compNo"  id="compNo" value="${compensationView.compNo}"/>

<aside class="title_line"><!-- title_line start -->
<h2>General</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />    
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Request Date</th>
    <td colspan="3">
    <%-- <input type="text" title="" id="issueDt" name="issueDt"  value="${compensationView.issueDt}" placeholder="" class="readonly " style="width: 157px; " /> --%>
    <input type="date" title="Create start Date" placeholder="yyyy/mm/dd" name="issueDt" id="issueDt" class="j_date" value="${compensationView.issueDt }" />
    </td>
    <th scope="row">Application Route</th>
    <td colspan="3">
    <input type="text" title="" id="asReqsterTypeId" name="asReqsterTypeId"  value="${compensationView.asReqsterTypeId}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row"> AS Order Number</th>
    <td colspan="3">
    <input type="text" title="" id="asNo" name="asNo"  value="${compensationView.asNo}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Order No</th>
    <td colspan="3">
    <input type="text" title="" id="salesOrdNo" name="salesOrdNo"  value="${compensationView.salesOrdNo}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
 <th scope="row">Customer name</th>
    <td colspan="3">
        <input type="text" title="" id="custId" name="custId"  value="${compensationView.custId}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Product name</th>
    <td colspan="3">
        <input type="text" title="" id="product" name="product"  value="" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td> 
</tr>

<tr>
    <th scope="row">Installation Date</th>
    <td colspan="3">
    <input type="text" title="" id="Installation" name="Installation"  value="" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
    <th scope="row">Serial No</th>
    <td colspan="3">
    <input type="text" title="" id="Serial" name="Serial"  value="" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>

<tr>
    <th scope="row">Status</th>
    <td colspan="3">
         <select  class="multy_select w100p" id="stusCodeId" name="stusCodeId">
                 <option value="1">Active</option>
                <option value="44">Pending</option>
                <option value="34">Solved</option>
                <option value="35">Unsolved</option>
                <option value="36">Closed</option>
                <option value="10">Cancelled</option>
        </select> 
    </td>  
    <th scope="row">Complete Date</th>
    <td colspan="3">
    <%-- <input type="date" title="" id="compDt" name="compDt" class="j_date2" value="${compensationView.compDt}" placeholder="" class="readonly "  style="width: 157px; "/> --%>
    <input type="date" title="Create start Date" placeholder="DD/MM/YYYY" name="compDt" id="compDt" class="j_date" value="${compensationView.compDt }" />
    </td>
</tr>
<tr>
    <th scope="row">RM</th>
    <td colspan="3">
    <input type="text" title="" id="compTotAmt" name="compTotAmt"  value="${compensationView.compTotAmt}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
    <th scope="row">Managing Department</th>
    <td colspan="3">
    <%-- <input type="text" title="" id="mainDept" name="mainDept"  value="${compensationView.mainDept}" placeholder="" class="readonly " style="width: 157px; "/> --%>
    <select class="w100p" id="searchdepartment" name="searchdepartment"  ></select>
    <select class="w100p" id="inputSubDept" name="inputSubDept"></select>
    </td>   
</tr>
<tr>
<th scope="row">DSC</th>
    <td colspan="7">
     <select id="code" name="code" class="w100p" >
     <%-- <option value="">Choose One</option>
      <c:forEach var="list" items="${ssCapacityCtList }">
         <option value="${list.codeId }">${list.codeName }</option>
         <option value="${list.codeId }">${list.codeName }</option>
      </c:forEach> --%>
 </select>
</tr>
</tbody>
</table><!-- table end -->
 
<aside class="title_line"><!-- title_line start -->
<h2>Detail Log</h2>
</aside><!-- title_line end -->

  
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />    
</colgroup>
<tbody>
<tr>
        <th scope="row">Defect Parts</th>
    <td colspan="3">
    <input type="text" title=""  id='asrItmPart' name ='asrItmPart' placeholder="ex) DT3" class=""  onChange="fn_getASReasonCode2(this, 'asrItmPart' ,'387')" />
    <input type="hidden" title=""  id='asrItmPart_id'    name ='asrItmPart_id' placeholder="" class="" />
    <input type="text" title="" placeholder="" id='asrItmPart_text' name ='asrItmPart_text'   class="" />
    </td>
    <th scope="row">Leaking/burning</th>
    <td colspan="3">
    <input type="text" title="" id="asDefectTypeId" name="asDefectTypeId"  value="${compensationView.asDefectTypeId}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Settlement Method</th>
    <td colspan="3">
    <input type="text" title="" placeholder="ex) A9" class=""  id='asSlutnResn' name ='asSlutnResn'  onChange="fn_getASReasonCode2(this, 'asSlutnResn'  ,'337')"   />
    <input type="hidden" title="" placeholder="" class=""   id='asSlutnResn_id' name ='asSlutnResn_id'  value="${compensationView.asMalfuncResnId}"  />
    <input type="text" title="" placeholder="" class=""   id='asSlutnResn_text' name ='asSlutnResn_text'  />
    </td>
    <th scope="row">Reason</th>
    <td colspan="3">
    <input type="text" title="" id="asMalfuncResnId" name="asMalfuncResnId"  value="${compensationView.asMalfuncResnId}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Compensation Item</th>
    <td colspan="3">
        <input type="text" title="" id="compItem1" name="compItem1"  value="${compensationView.compItem1}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>
<th scope="row">Compensation Item</th>
    <td colspan="3">
    <input type="text" title="" id="compItem2" name="compItem2"  value="${compensationView.compItem2}" placeholder="" class="readonly " style="width: 157px; "/>
    </td>    
</tr>
<tr>

    <th scope="row">Compensation Item</th>
    <td colspan="7">
    <input type="text" title="" id="compItem3" name="compItem3"  value="${compensationView.compItem3}" placeholder="" class="readonly " style="width: 157px; "/>
    </td> 
</tr>
 
 <tr>
    <th scope="row">attachment</th>
    <td colspan="7">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" id="attachFile" value="${compensationView.attachFile}"/>
    </div><!-- auto_file end -->
    </td>    
 </tr>
</tbody>
</table><!-- table end -->
    

  
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#"  onclick="fn_doSave()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>