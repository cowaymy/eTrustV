<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 생성 후 반환 ID
var bankAccountGirdID; // bank account list

$(document).ready(function(){
    
	/*  Gird */
    //AUIGrid 그리드를 생성합니다. (address, contact , bank, creditcard, ownorder, thirdparty )
    createBankGrid();
    fn_getCustomerBankAjax(); // bank account list
	
	/* Move Page */
    $("#_editCustomerInfo").change(function(){
          
        var stateVal = $(this).val();
        $("#_selectParam").val(stateVal);
        
    });
    
    $("#_confirm").click(function (currPage) {
        var status = $("#_selectParam").val();
       
        if(status == '1'){
            if('${PAGE_AUTH.funcUserDefine2}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerBasicInfoPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv1');
                $("#_close").click();
            }else{
                Common.alert("access deny.");
            }
        }
        if(status == '2'){
            if('${PAGE_AUTH.funcUserDefine3}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2');
                $("#_close").click();
            }else{
                Common.alert("access deny.");
            }
        }
        if(status == '3'){
            if('${PAGE_AUTH.funcUserDefine4}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerContactPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv3');
                $("#_close").click();
            }else{
                Common.alert("access deny.");
            }
        }
        if(status == '4'){
            if('${PAGE_AUTH.funcUserDefine5}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerBankAccountPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv4');
                $("#_close").click();
            }else{
                Common.alert("access deny.");
            }
        }
        if(status == '5'){
            if('${PAGE_AUTH.funcUserDefine6}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerCreditCardPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv5');
                $("#_close").click();
            }else{
                Common.alert("access deny.");
            }
        }
        if(status == '6'){ 
            if('${PAGE_AUTH.funcUserDefine7}' == 'Y'){
                Common.popupDiv("/sales/customer/updateCustomerBasicInfoLimitPop.do", $("#popForm").serializeJSON(), null , true , '_editDiv6');
                $("#_close").click();
            }else{
                Common.alert("access deny.");
            }
        }
    });
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(bankAccountGirdID, "cellDoubleClick", function(event){
        $("#_editCustId").val(event.item.custId);
        $("#_editCustBankId").val(event.item.custAccId); 
        Common.popupDiv("/sales/customer/updateCustomerBankAccEditInfoPop.do", $("#editForm").serializeJSON(), null , true, '_editDiv4Pop');
    });
    
    $("#_newBank").click(function() {
    	Common.popupDiv('/sales/customer/updateCustomerNewBankPop.do', $("#popForm").serializeJSON(), null , true ,'_editDiv4New');
	});
    
});// Document Ready End
     
    function createBankGrid(){
	
    	// Bank Column
        var bankColumnLayout= [
               {dataField : "custAccOwner", headerText : "Account Holder", width : '25%'}, 
               {dataField : "codeName", headerText : "Type", width : '25%'}, 
               {dataField : "bankName", headerText : "Issue Bank", width : '25%'},
               {dataField : "custAccNo", headerText : "Account No", width : '25%'},
               {dataField : "custAccId" , visible : false},
               {dataField : "custId" , visible : false}
         ];
    	
      //그리드 속성 설정
        var gridPros = {
                
                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 1,            
                showStateColumn     : true,             
                displayTreeOpen     : false,            
                selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
        };
      
        bankAccountGirdID = GridCommon.createAUIGrid("#bank_grid_wrap", bankColumnLayout,'',gridPros); // bank account list
	
    }

    //Get address by Ajax
     function fn_getCustomerBankAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerBankAccJsonList",$("#popForm").serialize(), function(result) {
            AUIGrid.setGridData(bankAccountGirdID, result);
        });
    }
    
   //close Func
     function fn_closeFunc(){
          $("#_selectParam").val('1');
     }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Customer Bank Account Maintenance</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" onclick="javascript: fn_closeFunc()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<!-- move Page Form  -->
<form id="editForm">
    <input type="hidden" name="custId" value="${custId}"/>
    <input type="hidden" name="custAddId" value="${custAddId}"/>
    <input type="hidden" name="custCntcId" value="${custCntcId}" > 
    <input type="hidden" name="custAccId" value="${custAccId}" id="custAccId">
    <input type="hidden" name="selectParam"  id="_selectParam"/>
</form>
<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">EDIT Type</th>
    <td>
     <select id="_editCustomerInfo">
        <option value="1" <c:if test="${selectParam eq 1}">selected</c:if>>Edit Basic Info</option>
        <option value="2" <c:if test="${selectParam eq 2}">selected</c:if>>Edit Customer Address</option>
        <option value="3" <c:if test="${selectParam eq 3}">selected</c:if>>Edit Contact Info</option>
        <option value="4" <c:if test="${selectParam eq 4}">selected</c:if>>Edit Bank Account</option>
        <option value="5" <c:if test="${selectParam eq 5}">selected</c:if>>Edit Credit Card</option>
        <option value="6" <c:if test="${selectParam eq 6}">selected</c:if>>Edit Basic Info(Limit)</option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm">Confirm</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Main Address</a></li>
    <li><a href="#">Main Contact</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>${result.custId}</span></td>
    <th scope="row">Customer Type</th>
    <td>
        <span> 
                ${result.codeName1}
                <!-- not Individual -->  
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
    </td>
    <th scope="row">Create At</th>
    <td>${result.crtDt}</td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">${result.name}</td>
    <th scope="row">Create By</th>
    <td>
        <c:if test="${result.crtUserId ne 0}">
                ${result.userName}
            </c:if>
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td><span>${result.nric}</span></td>
    <th scope="row">GST Registration No</th>
    <td>${result.gstRgistNo}</td>
    <th scope="row">Update By</th>
    <td>${result.userName1}</td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${result.email}</span></td>
    <th scope="row">Nationality</th>
    <td>${result.cntyName}</td>
    <th scope="row">Update At</th>
    <td>${result.updDt}</td>
</tr>
<tr>
    <th scope="row">Gender</th>
    <td><span>${result.gender}</span></td>
    <th scope="row">DOB</th>
    <td>
        <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
        </c:if>
    </td>
    <th scope="row">Race</th>
    <td>${result.codeName2 }</td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td><span>${result.pasSportExpr}</span></td>
    <th scope="row">Visa Expire</th>
    <td>${result.visaExpr}</td>
    <th scope="row">VA Number</th>
    <td>${result.custVaNo}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span>${result.rem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
<!-- ######### main address info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Full Address</th>
    <td>
        <span>${addresinfo.fullAddress}</span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>${addresinfo.rem}</td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<!-- ######### main Contact info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td><span>${contactinfo.name1}</span></td>
    <th scope="row">Initial</th>
    <td><span>${contactinfo.code}</span></td>
    <th scope="row">Genders</th>
    <td>
            <c:choose >
                <c:when test="${contactinfo.gender eq 'M'}">
                     Male
                </c:when>
                <c:when test="${contactinfo.gender eq 'F'}">
                     Female
                </c:when>
                <c:otherwise>
                    <!-- korean : 5  -->                    
                </c:otherwise>
            </c:choose>
     </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${contactinfo.nric}</span></td>
    <th scope="row">DOB</th>
    <td>
        <span>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if> 
        </span>
    </td>
    <th scope="row">Race</th>
    <td><span>${contactinfo.codeName}</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${contactinfo.email}</span></td>
    <th scope="row">Department</th>
    <td><span>${contactinfo.dept}</span></td>
    <th scope="row">Post</th>
    <td><span>${contactinfo.pos}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>${contactinfo.telM1}</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${contactinfo.telR}</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${contactinfo.telO}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td>${contactinfo.telf}</td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
</section><!-- tap_wrap end -->
<!-- ########## Basic Info End ##########  -->
<aside class="title_line mt30"><!-- title_line start -->
<h3>Customer Bank Account List</h3>
</aside><!-- title_line end -->
<!-- ########## Bank Acc Grid Start ########## -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="_newBank">ADD New Bank Account</a></p></li> <!-- xml :   insertBankAccountInfo -->
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="bank_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<!-- ########## Bank Acc Grid End ########## -->
</section><!-- pop_body end -->
</div>