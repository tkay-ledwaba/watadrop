from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from rest_framework.decorators import api_view
from rest_framework.response import Response


from api.models.account import Account
from api.serializers.account_serializer import AccountSerializer


class AccountViews(APIView):
    def post(self, request):
        serializer = AccountSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
        else:
            return Response({"status": "error", "data": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
        
@api_view(['GET'])
def getAccounts(request):
    accounts = Account.objects.all()
    serializer = AccountSerializer(accounts, many=True)

    return Response(serializer.data)