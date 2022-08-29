using Amazon.CDK;
using Constructs;
using Amazon.CDK.AWS.EC2;
using Amazon.CDK.AWS.ECS;
using Amazon.CDK.AWS.ECS.Patterns;
using Amazon.CDK.AWS.RDS;

namespace TestAssigment
{
    public class TestAssigmentStack : Stack
    {
        internal TestAssigmentStack(Construct scope, string id, IStackProps props = null) : base(scope, id, props)
        {
            var dbName = "MyWebAppDB";
            var dbUsername = "admin";


            // Set up VPCs for webapp and the database

            var web_vpc = new Vpc(this, "MyWebVpc", new VpcProps
            {
                MaxAzs = 2
            });

            var db_vpc = new Vpc(this, "MyDbVpc", new VpcProps
            {
                MaxAzs = 2
            });


            // Set up a webapp deployment cluster

            var cluster = new Cluster(this, "MyWebAppCluster", new ClusterProps
            {
                Vpc = web_vpc
            });


            // Deploy a database instance

            var database = new DatabaseInstance(this, "MySQL_DB", new DatabaseInstanceProps
            {
                DatabaseName = dbName,
                InstanceIdentifier = dbName,
                Credentials = Credentials.FromGeneratedSecret(dbUsername, new CredentialsBaseOptions
                {
                    SecretName = "MyWebAppDbSecret"
                }),
                AllocatedStorage = 10,
                Engine = DatabaseInstanceEngine.Mysql(new MySqlInstanceEngineProps
                {
                    Version = MysqlEngineVersion.VER_8_0_28
                }),
                Vpc = db_vpc,
                InstanceType = InstanceType.Of(InstanceClass.T4G, InstanceSize.MICRO),
                PubliclyAccessible = false // delete this to make DB accessible from the internet
            });

            
            // Deploy a pair of docker containers using Dockerfile in the root of the deployment project

            var service = new ApplicationLoadBalancedFargateService(
                this, "ecs_service", new ApplicationLoadBalancedFargateServiceProps
                {
                    Cluster = cluster,
                    TaskImageOptions = new ApplicationLoadBalancedTaskImageOptions
                    {
                        Image = ContainerImage.FromAsset(".")
                    },
                    DesiredCount = 2
                });


            // Output some useful infos about a successful deployment

            new CfnOutput(this, "MysqlEndpoint", new CfnOutputProps
            {
                Description = "MysqlEndPoint",
                Value = database.DbInstanceEndpointAddress,
            });

            new CfnOutput(this, "MysqlUserName", new CfnOutputProps
            {
                Description = "MysqlUserName",
                Value = dbUsername,
            });

            new CfnOutput(this, "MysqlDbName", new CfnOutputProps
            {
                Description = "MysqlDbName",
                Value = dbName,
            });

            new CfnOutput(this, "URL", new CfnOutputProps
            {
                Description = "Public DNS",
                Value = service.LoadBalancer.LoadBalancerDnsName
            });
        }
    }
}
